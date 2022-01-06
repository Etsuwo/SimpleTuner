//
//  UIView+Extension.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/03.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func cardView() {
        self.layer.cornerRadius = 8
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
