//
//  AnalyticsEvent.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/03.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation

protocol AnalyticsEvent {
    var eventName: String { get }
    var parameters: [String: Any] { get }
}
