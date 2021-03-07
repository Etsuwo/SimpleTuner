//
//  SoundMaterViewController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2020/11/28.
//  Copyright © 2020 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift
import XLPagerTabStrip

class SoundMaterViewController: UIViewController {
    
    @IBOutlet weak var soundBar1: UIView!
    @IBOutlet weak var soundBar2: UIView!
    @IBOutlet weak var soundBar3: UIView!
    @IBOutlet weak var soundBar4: UIView!
    @IBOutlet weak var soundBar5: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    var soundBarColor: UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.5)
    let disposeBag = DisposeBag()
    let lineWidth: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundAnalizer.shared.soundMaterDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataBind()
        SoundAnalizer.shared.startSoundMater()
        print("sound mater start")
    }
    
    func dataBind() {
        UserInfo.shared.colorEvent.subscribe(onNext: {
            color in
            self.drawLabelUnderLine(color: color.main)
            self.soundBarColor = color.sub
        }).disposed(by: disposeBag)
    }
    
    func drawLabelUnderLine(color: UIColor) {
        titleLabel.layer.addSublayer(CALayer.drawUnderLine(lineWidth: lineWidth, lineColor: color, UI: titleLabel))
        unitLabel.layer.addSublayer(CALayer.drawUnderLine(lineWidth: lineWidth, lineColor: color, UI: unitLabel))
    }
}

extension SoundMaterViewController: SoundMaterDelegate {
    func soundMaterDidMesure(dB: Double) {
        print(dB)
        amplitudeLabel.text = String(format: "%.0f", dB)
        let index = Int(dB / 20)
        let soundBars = [soundBar1, soundBar2, soundBar3, soundBar4, soundBar5]
        soundBars.forEach({ soundBar in
            soundBar?.backgroundColor = UIColor.lightGray
        })
        for count in 0 ... index {
            soundBars[count]?.backgroundColor = soundBarColor
        }
    }
}

extension SoundMaterViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "Sound", image: UIImage(named: "sound")?.withRenderingMode(.alwaysTemplate))
        return info
    }
}
