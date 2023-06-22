//
//  TunerViewModel.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/02.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class TunerViewModel {
    
    struct ViewState {
        fileprivate let baseFrequency = PublishRelay<Double>()
        fileprivate let pitchFrequency = PublishRelay<Double>()
        fileprivate let note = PublishRelay<Note>()
        fileprivate let frequency = PublishRelay<Double>()
        fileprivate let themeColor = PublishRelay<ThemeColor>()
        fileprivate let onMoveArrowView = PublishRelay<(Pitch, Double)>()
        var baseFrequencyEvent: Observable<Double> { return baseFrequency.asObservable() }
        var pitchFrequencyEvent: Observable<Double> { return pitchFrequency.asObservable() }
        var noteEvent: Observable<Note> { return note.asObservable() }
        var frequencyEvent: Observable<Double> { return frequency.asObservable() }
        var themeColorEvent: Observable<ThemeColor> { return themeColor.asObservable() }
        var onMoveArrowViewEvent: Observable<(Pitch, Double)> { return onMoveArrowView.asObservable() }
    }
    
    private let disposeBag = DisposeBag()
    private let tuner = Tuner()
    let viewState = ViewState()
    
    init() {
        UserInfo.shared.baseFrequencyEvent
            .subscribe(onNext: { [weak self] baseFrequency in
                self?.viewState.baseFrequency.accept(baseFrequency)
            })
            .disposed(by: disposeBag)
        UserInfo.shared.colorEvent
            .subscribe(onNext: { [weak self] color in
                self?.viewState.themeColor.accept(color)
            })
            .disposed(by: disposeBag)
        tuner.tunerPublisher
            .subscribe(onNext: {[weak self] (pitch, distance, amplitude, frequency) in
                guard amplitude > 0.1,
                      frequency > Pitch.all[0].frequency,
                      frequency < Pitch.all[60].frequency else {
                    return
                }
                self?.viewState.pitchFrequency.accept(pitch.frequency)
                self?.viewState.note.accept(pitch.note)
                self?.viewState.frequency.accept(frequency)
                self?.viewState.onMoveArrowView.accept((pitch, frequency))
                
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        viewState.themeColor.accept(LocalDataStore().themeColor)
        viewState.baseFrequency.accept(LocalDataStore().baseFrequency)
    }
    
    func startTuner() {
        tuner.analizer.start()
    }
    
    func stopTuner() {
        tuner.analizer.stop()
    }
    
    func onTapPlusButton() {
        tuner.addBaseFrequency()
    }
    
    func onTapMinusButton() {
        tuner.subBaseFrequency()
    }
}
