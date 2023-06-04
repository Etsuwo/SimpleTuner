//
//  AnalyticsSelectContent.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/03.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct AnalyticsSelectContent: AnalyticsEvent {
    var parameters: [any AnalyticsParameter]
    
    var eventName: String {
        AnalyticsEventSelectContent
    }
}
