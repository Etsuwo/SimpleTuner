//
//  RemoteConfigProvider.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/06.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import AsyncAlgorithms

protocol RemoteConfigProviderProtocol {
    var updateEventChannel: AsyncChannel<Void> { get }
    func config()
    func syncConfig() async throws
    func listenConfigUpdate()
    func getConfig<T: ConfigKey>(key: T) -> T.valueType
}

final class FirebaseRemoteConfigProvider: RemoteConfigProviderProtocol {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    private let _updateEventChannel = AsyncChannel<Void>()
    
    nonisolated var updateEventChannel: AsyncChannel<Void> {
        _updateEventChannel
    }
    
    init() {
        config()
    }
    
    func config() {
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #endif
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        listenConfigUpdate()
    }
    
    func syncConfig() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            remoteConfig.fetchAndActivate { status, error in
                if let error = error {
                    continuation.resume(throwing: RemoteConfigProviderError.fetchFaild)
                }
                if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                    debugPrint("sync config udpate")
                    continuation.resume()
                } else {
                    continuation.resume(throwing: RemoteConfigProviderError.fetchFaild)
                }
            }
        }
    }
    
    func listenConfigUpdate() {
        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let _ = configUpdate, error == nil else {
                debugPrint("error listening for config update: \(String(describing: error?.localizedDescription))")
                return
            }
            self.remoteConfig.activate { [weak self] changed, error in
                guard let self else { return }
                Task {
                    guard error == nil, changed else {
                        return
                    }
                    debugPrint("listening config udpate")
                    await self._updateEventChannel.send(())
                }
            }
        }
    }
    
    func getConfig<T>(key: T) -> T.valueType where T : ConfigKey {
        key.getConfig(remoteConfig: remoteConfig)
    }
}

enum RemoteConfigProviderError: Error {
    case fetchFaild
}
