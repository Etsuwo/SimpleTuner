//
//  MetroCountView.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/08/26.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import UIKit

class MetroCountView: UIView {
    
    private let circle1 = CircleLayer()
    private let circle2 = CircleLayer()
    private let circle3 = CircleLayer()
    private let circle4 = CircleLayer()
    private let circle5 = CircleLayer()
    private let circle6 = CircleLayer()
    var color: ThemeColor = .blue
    
    var beatNumber = 4
    
    func makeView() {
        let xCenter = self.frame.width * 0.5
        let height = self.frame.height
        let materWidth = self.frame.width * 0.8
        let space = materWidth / CGFloat(beatNumber - 1)
        let diameter = xCenter * 0.1
        let radious = diameter * 0.5
        var leftSide = self.frame.width * 0.1 - radious
        let circles = [circle1, circle2, circle3, circle4, circle5, circle6]
        
        for i in 0 ..< beatNumber {
            let circle = circles[i]
            circle.path = UIBezierPath(ovalIn: CGRect.init(x: leftSide, y: height, width: diameter, height: diameter)).cgPath
            circle.drawCircle(frame: self.frame)
            self.layer.addSublayer(circle)
            leftSide = leftSide + space
           }
    }
    
    func circleLighting(beatCount: Int) {
        let circles = [circle1, circle2, circle3, circle4, circle5, circle6]
        for i in 0 ..< beatCount {
            let circle = circles[i]
            circle.lightOff()
        }
        if beatCount == 0 {
            circles[beatNumber - 1].lightOff()
        }
        let circle = circles[beatCount]
        circle.lighting(color: color)
    }
    
    func refresh() {
        let circles = [circle1, circle2, circle3, circle4, circle5, circle6]
        for i in 0 ..< beatNumber {
            circles[i].lightOff()
        }
    }
}
