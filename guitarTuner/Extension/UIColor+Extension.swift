//
//  UIColor+Extension.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/03.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import UIKit

extension UIColor {
    class var mainBackground: UIColor {
        guard let color = UIColor(named: "mainBackground") else {
            return UIColor.white
        }
        return color
    }
    
    class var mainTextColor: UIColor {
        guard let color = UIColor(named: "mainTextColor") else {
            return UIColor.white
        }
        return color
    }
}
