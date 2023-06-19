//
//  AnalyticsThemeColor.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/03.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation

struct AnalyticsThemeColor: AnalyticsParameter {
    
    let themeColor: ThemeColor
    
    var name: String {
        "theme_color"
    }
    
    var value: String {
        themeColor.name
    }
}
