//
//  Tuner.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/06.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import RxSwift

final class Tuner: TunerDelegate {
    
    let analyzer = SoundAnalizer()
    var tunerPublisher = PublishSubject<(Pitch, Double, Double, Double)>()
    
    var baseFrequencyRange: Range<Double> {
        440 ..< 443
    }
    
    init() {
        analyzer.tunerDelegate = self
    }
    
    func didTrackFrequency(frequency: Double, amplitude: Double) {
        let pitch = Pitch.nearest(frequency)
        let distance = frequency - pitch.frequency
        tunerPublisher.on(.next((pitch, distance, amplitude, frequency)))
    }
    
    func addBaseFrequency() {
        guard baseFrequencyRange.contains(Pitch.baseFrequency + 1) else {
            print("##### Over BaseFrequency Range #####")
            return
        }
        Pitch.baseFrequency += 1
        Pitch.renewAll()
        UserInfo.shared.setBaseFrequency(baseFrequency: Pitch.baseFrequency)
    }
    
    func subBaseFrequency() {
        guard baseFrequencyRange.contains(Pitch.baseFrequency - 1) else {
            print("##### Over BaseFrequency Range #####")
            return
        }
        Pitch.baseFrequency -= 1
        Pitch.renewAll()
        UserInfo.shared.setBaseFrequency(baseFrequency: Pitch.baseFrequency)
    }
}
