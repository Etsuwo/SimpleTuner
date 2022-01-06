//
//  VolumeMeter.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/06.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import RxSwift

final class VolumeMeter: VolumeMeterDelegate {
    
    let analyzer = SoundAnalizer()
    var volumeMeterPublisher = PublishSubject<Double>()
    
    init() {
        analyzer.volumeMeterDelagate = self
    }
    
    func didTrackAmplitude(amplitude: Double) {
        let base = 0.0001
        let dB = 20 * log10(amplitude / base)
        guard amplitude > 0 else {
            print("amplitude is 0 ")
            return
        }
        volumeMeterPublisher.on(.next(dB))
    }
}
