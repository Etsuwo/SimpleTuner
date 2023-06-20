//
//  AnalyticsParameter.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/03.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation

protocol AnalyticsParameter {
    associatedtype T
    var name: String { get }
    var value: T { get }
}
