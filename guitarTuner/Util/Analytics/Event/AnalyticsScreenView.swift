//
//  AnalyticsScreenView.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/03.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct AnalyticsScreenView: AnalyticsEvent {
    var parameters: [String: Any] {
        [screenView.name: screenView.value]
    }
    
    var eventName: String {
        AnalyticsEventScreenView
    }
    
    let screenView: AnalyticsScreenType
}
