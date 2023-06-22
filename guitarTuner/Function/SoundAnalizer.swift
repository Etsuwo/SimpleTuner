//
//  tuner.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/04/08.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import RxSwift

protocol TunerDelegate {
    var baseFrequencyRange: Range<Double> { get }
    func didTrackFrequency(frequency: Double, amplitude: Double)
    func addBaseFrequency()
    func subBaseFrequency()
}

protocol VolumeMeterDelegate {
    func didTrackAmplitude(amplitude: Double)
}
 
class SoundAnalizer {
    
    static let shared = SoundAnalizer()
    
    private let engine = AudioEngine()
    private let mic: AudioEngine.InputNode
    private let silence: Fader
    private var tracker: PitchTap!
    
    var isPlaying = false
    
    var volumeMeterDelagate: VolumeMeterDelegate?
    var tunerDelegate: TunerDelegate?
    
    private init() {
        guard let input = engine.input else {
            fatalError("faield to start AudioKit")
        }
        print(Pitch.baseFrequency)
        mic = input
        let tappableNodeA = Fader(mic)
        let tappableNodeB = Fader(tappableNodeA)
        let tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        tracker = PitchTap(mic) { [weak self] frequencyArray, amplitudeArray in
            DispatchQueue.main.async {
                let frequency = Double(frequencyArray[0])
                let amplitude = Double(amplitudeArray[0])
                self?.tunerDelegate?.didTrackFrequency(frequency: frequency, amplitude: amplitude)
                self?.volumeMeterDelagate?.didTrackAmplitude(amplitude: amplitude)
            }
        }
    }
    
    func start() {
        do{
            try engine.start()
            tracker.start()
            isPlaying = true
            print("##### start AudioKit #####")
        }catch{
            fatalError("failed to start AudioKit")
        }
    }
    
    func stop() {
        engine.stop()
        isPlaying = false
    }
}
