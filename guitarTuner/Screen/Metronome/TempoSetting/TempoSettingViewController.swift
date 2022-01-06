//
//  TempoSettingViewController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2021/03/07.
//  Copyright © 2021 大谷悦志. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class TempoSettingViewController: UIViewController {
    
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var numberPadView: NumberPadView!
    
    private var tempo: Int!
    private var dismissed: ((Double) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberPadView.delegate = self
        tempoLabel.text = String(tempo)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        numberPadView.makeView()
    }
    
    func configure(with tempo: Int, dismissed: ((Double)->())? = nil) {
        self.tempo = tempo
        self.dismissed = dismissed
    }
}

extension TempoSettingViewController: NumberPadViewDelegate {
    func numberButtonTapped(number: String) {
        if numberPadView.firstTouch {
            tempoLabel.text = number
            numberPadView.firstTouch = false
            return
        }
        
        if tempoLabel.text == "0" {
            tempoLabel.text = number
            return
        }
        
        if var tempoLabelText = tempoLabel.text{
            tempoLabelText = tempoLabelText + number
            if Int(tempoLabelText)! > 300 {
                tempoLabel.text = "300"
                return
            }else{
                tempoLabel.text = tempoLabelText
            }
        }else{
            tempoLabel.text = number
        }
    }
    
    func CLButtonTapped() {
        tempoLabel.text = "0"
        numberPadView.firstTouch = true
    }
    
    func SETButtonTapped() {
        guard let tempoLabelText = tempoLabel.text,
              let settedTempo = Double(tempoLabelText),
              settedTempo > 0 else {
            return
        }
        numberPadView.firstTouch = true
        self.dismiss(animated: true, completion: { [weak self] in
            self?.dismissed?(settedTempo)
        })
    }
}
