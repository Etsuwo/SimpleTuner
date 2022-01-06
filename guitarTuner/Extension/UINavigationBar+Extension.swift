//
//  UINavigationBar.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/06.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func updateColorAppearance(color: UIColor) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
            standardAppearance = appearance
            
        } else {
            barTintColor = color
            titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}
