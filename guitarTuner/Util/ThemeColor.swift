//
//  Color.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2021/01/06.
//  Copyright © 2021 大谷悦志. All rights reserved.
//

import UIKit

enum ThemeColor: Int, CaseIterable, Codable {
    case blue
    case red
    case yellow
    case green
    case beige
    
    var name: String {
        switch self {
        case .blue:
            return "Blue"
        case .red:
            return "Red"
        case .yellow:
            return "Yellow"
        case .green:
            return "Green"
        case .beige:
            return "Beige"
        }
    }

    var main: UIColor {
        let color: UIColor?
        switch self {
        case .blue:
            color = UIColor(named: "mainBlue")
        case .red:
            color = UIColor(named: "mainRed")
        case .yellow:
            color = UIColor(named: "mainYellow")
        case .green:
            color = UIColor(named: "mainGreen")
        case .beige:
            color = UIColor(named: "mainBeige")
        }
        guard let mainColor = color else {
            fatalError()
        }
        return mainColor
    }
    
    var sub: UIColor {
        let color: UIColor?
        switch self {
        case .blue:
            color = UIColor(named: "subBlue")
        case .red:
            color = UIColor(named: "subRed")
        case .yellow:
            color = UIColor(named: "subYellow")
        case .green:
            color = UIColor(named: "subGreen")
        case .beige:
            color = UIColor(named: "subBeige")
        }
        guard let subColor = color else {
            fatalError()
        }
        return subColor
    }
    
    var tab: UIColor {
        let color: UIColor?
        switch self {
        case .blue:
            color = UIColor(named: "tabBlue")
        case .red:
            color = UIColor(named: "tabRed")
        case .yellow:
            color = UIColor(named: "tabYellow")
        case .green:
            color = UIColor(named: "tabGreen")
        case .beige:
            color = UIColor(named: "tabBeige")
        }
        guard let tabColor = color else {
            fatalError()
        }
        return tabColor
    }
}
