//
//  AnalyticsScreenType.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/03.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsScreenType: AnalyticsParameter {
    case tuner
    case volumeMeter
    case metronome
    case setting
    case selectColor
    
    var name: String { AnalyticsParameterScreenName }
    
    var value: String {
        switch self {
        case .tuner: return TunerViewController.className
        case .volumeMeter: return VolumeMaterViewController.className
        case .metronome: return MetronomeController.className
        case .setting: return SettingViewController.className
        case .selectColor: return SelectColorViewController.className
        }
    }
}
