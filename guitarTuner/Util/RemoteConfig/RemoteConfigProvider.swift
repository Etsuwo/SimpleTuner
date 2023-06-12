//
//  RemoteConfigProvider.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/06.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigProviderProtocol {
    func syncConfig() async throws
    func listenConfigUpdate() async throws -> AsyncStream<Void>
    func getConfig<T: ConfigKey>(key: T) -> T.valueType
}

final class FirebaseRemoteConfigProvider: RemoteConfigProviderProtocol {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    func config() {
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #endif
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    func syncConfig() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            remoteConfig.fetchAndActivate { status, error in
                if let error = error {
                    continuation.resume(throwing: RemoteConfigProviderError.fetchFaild)
                }
                if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: RemoteConfigProviderError.fetchFaild)
                }
            
            }
        }
    }
    
    func listenConfigUpdate() async throws -> AsyncStream<Void> {
        AsyncStream { continuation in
            remoteConfig.addOnConfigUpdateListener { configUpdate, error in
                guard let _ = configUpdate, error == nil else {
                    debugPrint("error listening for config update: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.remoteConfig.activate { changed, error in
                    guard error == nil, changed else {
                        return
                    }
                    continuation.yield()
                }
            }
        }
    }
    
    func getConfig<T>(key: T) -> T.valueType where T : ConfigKey {
        key.getConfig()
    }
}

enum RemoteConfigProviderError: Error {
    case fetchFaild
}
