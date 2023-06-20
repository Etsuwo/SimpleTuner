//
//  AnalyticsContnetName.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/04.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation

enum AnalyticsContentName: AnalyticsParameter {
    case selectThemeColor
    
    var name: String {
        "content_name"
    }
    
    var value: String {
        switch self {
        case .selectThemeColor: return "select_theme_color"
        }
    }
}
