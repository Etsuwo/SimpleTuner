//
//  AnalyticsLogger.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/05/18.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsLogger {
    func logScreenView(screen: AnalyticsScreenType)
}
