//
//  SettingTableSection.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/03.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation

enum SettingTableSections: Int {
    case settings
    case others
    
    enum SettingsSection {
        case themeColor
    }
    
    enum OthersSection: Int {
        case version
        case review
        case feedback
    }
}
