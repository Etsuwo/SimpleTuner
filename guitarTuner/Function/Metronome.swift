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

protocol MetronomeDelegate: class {
    func metronomeDidBeat(currentBeat: Int)
}

class Metoronome {
    let engine = AudioEngine()
    let shaker = Shaker()
    var callbackInst = CallbackInstrument()
    let reverb: Reverb
    let mixer = Mixer()
    var sequencer = Sequencer()
    private var data = ShakerMetronomeData()
    
    weak var delegate: MetronomeDelegate?
    
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
            self.delegate?.metronomeDidBeat(currentBeat: Int(beat))
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
        } catch let err {
            print(err.localizedDescription)
        }
    }

    func stop() {
        sequencer.stop()
        engine.stop()
        data.isPlaying = false
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
        UserInfo.shared.setTempo(tempo: data.tempo)
    }
    
    func tempoMinus1() {
        data.tempo -= 1
        sequencer.tempo = data.tempo
        UserInfo.shared.setTempo(tempo: data.tempo)
    }
    
    func setTenpo(settedTenpo: Double) {
        data.tempo = settedTenpo
        sequencer.tempo = data.tempo
        UserInfo.shared.setTempo(tempo: data.tempo)
    }
}
