//
//  LocalDataStore.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/02.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

final class LocalDataStore {
    var themeColor: ThemeColor {
        get {
            ThemeColor(rawValue: Defaults.themeColor)!
        }
        set(color) {
            Defaults.themeColor = color.rawValue
        }
    }
    
    var baseFrequency: Double {
        get {
            Defaults.baseFrequency
        }
        set(frequency) {
            Defaults.baseFrequency = frequency
        }
    }
}
