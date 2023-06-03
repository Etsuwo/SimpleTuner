//
//  FirebaseAnalyticsLogger.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/05/18.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsLogger: AnalyticsLogger {
    
    static let shared = FirebaseAnalyticsLogger()
    
    private init() {}
    
    func logScreenView(screen: AnalyticsScreenType) {
        log(event: AnalyticsScreenView(parameters: [screen]))
    }
    
    func log(event: AnalyticsEvent) {
        var params: [String: Any] = [:]
        event.parameters.forEach { parameter in
            params[parameter.name] = parameter.value
        }
        Analytics.logEvent(event.eventName, parameters: params)
    }
}
