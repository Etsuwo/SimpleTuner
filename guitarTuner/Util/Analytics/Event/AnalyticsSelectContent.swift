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
    
    var parameters: [String: Any] {
        var params: [String: Any] = [contentName.name: contentName.value]
        contentParameters.forEach { parameter in
            params[parameter.name] = parameter.value
        }
        return params
    }
    
    var eventName: String {
        AnalyticsEventSelectContent
    }
    
    let contentName: AnalyticsContentName
    
    let contentParameters: [any AnalyticsParameter]
}
