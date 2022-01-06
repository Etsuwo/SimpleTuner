//
//  CircleLayer.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/08/19.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import UIKit

class CircleLayer: CAShapeLayer {
    
    var standardFrequency: Double?
    
    func drawCircle(frame: CGRect) {
        let strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let fillColor = UIColor.clear
        let frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        
        self.frame = frame
        self.strokeColor = strokeColor.cgColor
        self.fillColor = fillColor.cgColor
        
    }
    
    func lighting(color: ThemeColor) {
        DispatchQueue.main.async {
            self.fillColor = color.sub.cgColor
        }
    }
    
    func lightOff() {
        DispatchQueue.main.async {
            let fillColor = UIColor.clear
            self.fillColor = fillColor.cgColor
        }
    }

}
