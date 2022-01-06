//
//  VolumeMeterBarView.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/02.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import UIKit

final class VolumeMeterBarView: UIView {
    
    @IBOutlet weak var firstBar: UIView!
    @IBOutlet weak var secondBar: UIView!
    @IBOutlet weak var thirdBar: UIView!
    @IBOutlet weak var fouthBar: UIView!
    @IBOutlet weak var fifthBar: UIView!
    
    var soundBarColor: UIColor = ThemeColor.blue.sub
    
    func lightingSoundbars(amplitude: Double) {
        let index = Int(amplitude / 20)
        let soundBars = [firstBar, secondBar, thirdBar, fouthBar, fifthBar]
        soundBars.forEach({ soundBar in
            soundBar?.backgroundColor = UIColor.lightGray
        })
        for count in 0 ... index {
            soundBars[count]?.backgroundColor = soundBarColor
        }
    }
    
}
