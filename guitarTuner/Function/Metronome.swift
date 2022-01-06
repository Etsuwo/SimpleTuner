//
//  Metronome.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/01.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitEX
import STKAudioKit
import RxSwift
import RxRelay

class Metronome {
    let engine = AudioEngine()
    let shaker = Shaker()
    var callbackInst = CallbackInstrument()
    let reverb: Reverb
    let mixer = Mixer()
    var sequencer = Sequencer()
    private var data = ShakerMetronomeData()
        
    struct Publishers {
        fileprivate let didStart = PublishRelay<Void>()
        fileprivate let didStop = PublishRelay<Void>()
        fileprivate let didChangeTempo = PublishRelay<Double>()
        fileprivate let didBeat = PublishRelay<Int>()
        var didStartEvent: Observable<Void> { return didStart.asObservable() }
        var didStopEvent: Observable<Void> { return didStop.asObservable() }
        var didChangeTempoEvent: Observable<Double> { return didChangeTempo.asObservable() }
        var didBeatEvent: Observable<Int> { return didBeat.asObservable() }
    }
    
    let publishers = Publishers()
    
    struct ShakerMetronomeData {
        var isPlaying = false
        var tempo: BPM = 120
        var timeSignatureTop: Int = 4
        var downbeatNoteNumber = MIDINoteNumber(1)
        var beatNoteNumber = MIDINoteNumber(2)
        var beatNoteVelocity = 100.0
        var currentBeat = 0
    }
    
    init() {
        let fader = Fader(shaker)
        fader.gain = 20.0
        reverb = Reverb(fader)

        let _ = sequencer.addTrack(for: shaker)

        callbackInst = CallbackInstrument(midiCallback: { (_, beat, _) in
            self.data.currentBeat = Int(beat)
            self.publishers.didBeat.accept(Int(beat))
            print(beat)
        })

        let _ = sequencer.addTrack(for: callbackInst)
        sequencer.tempo = data.tempo
        updateSequences()

        mixer.addInput(reverb)
        mixer.addInput(callbackInst)

        engine.output = mixer

    }
    
    func updateSequences() {
        var track = sequencer.tracks.first!

        track.length = Double(data.timeSignatureTop)

        track.clear()
        track.sequence.add(noteNumber: data.downbeatNoteNumber, position: 0.0, duration: 0.4)
        let vel = MIDIVelocity(Int(data.beatNoteVelocity))
        for beat in 1 ..< data.timeSignatureTop {
            track.sequence.add(noteNumber: data.beatNoteNumber, velocity: vel, position: Double(beat), duration: 0.1)
        }

        track = sequencer.tracks[1]
        track.length = Double(data.timeSignatureTop)
        track.clear()
        for beat in 0 ..< data.timeSignatureTop {
            track.sequence.add(noteNumber: MIDINoteNumber(beat), position: Double(beat), duration: 0.1)
        }
    }
    
    func start() {
        do {
            try engine.start()
            sequencer.play()
            data.isPlaying = true
            publishers.didStart.accept(())
        } catch let err {
            print(err.localizedDescription)
        }
    }

    func stop() {
        sequencer.stop()
        engine.stop()
        data.isPlaying = false
        publishers.didStop.accept(())
    }
    
    func isPlaying() -> Bool {
        data.isPlaying
    }
    
    func getTempo() -> Double {
        data.tempo
    }
    
    func tempoPlus1() {
        data.tempo += 1
        sequencer.tempo = data.tempo
        publishers.didChangeTempo.accept(data.tempo)
        UserInfo.shared.setTempo(tempo: data.tempo)
    }
    
    func tempoMinus1() {
        data.tempo -= 1
        sequencer.tempo = data.tempo
        publishers.didChangeTempo.accept(data.tempo)
        UserInfo.shared.setTempo(tempo: data.tempo)
    }
    
    func setTenpo(settedTenpo: Double) {
        data.tempo = settedTenpo
        sequencer.tempo = data.tempo
        publishers.didChangeTempo.accept(data.tempo)
        UserInfo.shared.setTempo(tempo: data.tempo)
    }
}
