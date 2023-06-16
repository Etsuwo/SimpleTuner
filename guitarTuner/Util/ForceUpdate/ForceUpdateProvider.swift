//
//  ForceUpdateProvider.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/12.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation

protocol ForceUpdateProviderProtocol {
    func listenUpdate() async -> any AsyncSequence
    func checkUpdate() async throws -> ForceUpdate?
}

final class ForceUpdateProvider: ForceUpdateProviderProtocol {
    
    private let remoteConfigProvider: RemoteConfigProviderProtocol
    
    init(remoteConfigProvider: RemoteConfigProviderProtocol = FirebaseRemoteConfigProvider()) {
        self.remoteConfigProvider = remoteConfigProvider
    }
    
    func listenUpdate() async -> any AsyncSequence {
        remoteConfigProvider.updateEventChannel
            .map { [weak self] _ -> ForceUpdate? in
                guard let self else {
                    return nil
                }
                return self.createForceUpdate()
            }
            .compactMap { $0 }
    }
    
    func checkUpdate() async throws -> ForceUpdate? {
        do {
            try await remoteConfigProvider.syncConfig()
            return createForceUpdate()
        } catch {
            throw error
        }
    }
    
    private func createForceUpdate() -> ForceUpdate? {
        guard let requiredVersion = AppVersion(remoteConfigProvider.getConfig(key: ConfigKeys.StringKeys.requiredMinimumVersion)),
              let latestVersion = AppVersion(remoteConfigProvider.getConfig(key: ConfigKeys.StringKeys.latestVersion)),
              let currentVersion = AppVersion(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String) else {
            return nil
        }
        let storeUrl = remoteConfigProvider.getConfig(key: ConfigKeys.StringKeys.storeUrl)
        return ForceUpdate(latestVersion: latestVersion, requiredVersion: requiredVersion, currentVersion: currentVersion, storeUrl: storeUrl)
    }
    
    
}

struct ForceUpdate {
    let latestVersion: AppVersion
    let requiredVersion: AppVersion
    let currentVersion: AppVersion
    let storeUrl: String
    
    var requireUpdate: Bool {
        requiredVersion > currentVersion
    }
}

extension AsyncStream {
    func eraseOperatorType() async -> AsyncStream<Self.Element> {
        AsyncStream { continuation in
            Task {
                for await value in self {
                    continuation.yield(value)
                }
            }

        }
    }
}
