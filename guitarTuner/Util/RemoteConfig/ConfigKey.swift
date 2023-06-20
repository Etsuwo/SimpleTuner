//
//  ConfigKey.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/12.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig


protocol ConfigKey {
    associatedtype valueType
    var key: String { get }
    func getConfig(remoteConfig: RemoteConfig) -> valueType
}
