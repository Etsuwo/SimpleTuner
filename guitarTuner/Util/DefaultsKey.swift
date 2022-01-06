//
//  DefaultsKey.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/02.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum UserInfoDefaults: Int {
    case themeColor
    case baseFrequency
    
    var key: String {
        switch self {
        case .themeColor: return "themeColor"
        case .baseFrequency: return "baseFrequency"
        }
    }
}

extension DefaultsKeys {
    var themeColor: DefaultsKey<Int> {
        .init(UserInfoDefaults.themeColor.key, defaultValue: ThemeColor.blue.rawValue)
    }
    
    var baseFrequency: DefaultsKey<Double> {
        .init(UserInfoDefaults.baseFrequency.key, defaultValue: 440)
    }
}
