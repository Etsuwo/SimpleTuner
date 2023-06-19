//
//  StringConfig.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/12.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

protocol StringConfig: ConfigKey where valueType == String {}

extension StringConfig {
    func getConfig(remoteConfig: RemoteConfig) -> valueType {
        remoteConfig.configValue(forKey: key).stringValue ?? ""
    }
}

enum ConfigKeys {
    enum StringKeys: String, StringConfig {
        case requiredMinimumVersion = "required_minimum_version"
        case latestVersion = "latest_version"
        case storeUrl = "store_url"
        
        var key: String {
            rawValue
        }
    }
}
