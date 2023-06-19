//
//  ForceUpdateProvider.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/12.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import UIKit

protocol ForceUpdateProviderProtocol {
    func listenUpdate() async
    func checkUpdate() async
}

final class ForceUpdateProvider: ForceUpdateProviderProtocol {
    
    private let remoteConfigProvider: RemoteConfigProviderProtocol
    
    init(remoteConfigProvider: RemoteConfigProviderProtocol = FirebaseRemoteConfigProvider()) {
        self.remoteConfigProvider = remoteConfigProvider
    }
    
    func listenUpdate() async {
        let sequence = remoteConfigProvider.updateEventChannel
            .map { [weak self] _ -> ForceUpdate? in
                guard let self else {
                    return nil
                }
                return self.createForceUpdate()
            }
            .compactMap { $0 }
        
        for await forceUpdate in sequence {
            await showForceUpdateWindowIfNeed(forceUpdate: forceUpdate)
        }
    }
    
    func checkUpdate() async {
        do {
            try await remoteConfigProvider.syncConfig()
            guard let forceUpdate = createForceUpdate() else { return }
            await showForceUpdateWindowIfNeed(forceUpdate: forceUpdate)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func createForceUpdate() -> ForceUpdate? {
        guard let requiredVersion = AppVersion(remoteConfigProvider.getConfig(key: ConfigKeys.StringKeys.requiredMinimumVersion)),
              let latestVersion = AppVersion(remoteConfigProvider.getConfig(key: ConfigKeys.StringKeys.latestVersion)),
              let currentVersion = AppVersion(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String),
              let storeUrl = URL(string: remoteConfigProvider.getConfig(key: ConfigKeys.StringKeys.storeUrl)) else {
            return nil
        }
        return ForceUpdate(latestVersion: latestVersion, requiredVersion: requiredVersion, currentVersion: currentVersion, storeUrl: storeUrl)
    }
    
    private func showForceUpdateWindowIfNeed(forceUpdate: ForceUpdate) async {
        if forceUpdate.requireUpdate {
            await MainActor.run {
                let alertController = UIAlertController.makeForceUpdateAlert(latestVersion: forceUpdate.latestVersion.versionString, storeUrl: forceUpdate.storeUrl)
                PopupWindowHandler().show(viewController: alertController)
            }
        }
    }
}

struct ForceUpdate {
    let latestVersion: AppVersion
    let requiredVersion: AppVersion
    let currentVersion: AppVersion
    let storeUrl: URL
    
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
