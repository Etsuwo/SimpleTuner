//
//  MetronomeViewModel.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/02.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

final class MetronomeViewModel {
    struct ViewState {
        fileprivate let themeColor = PublishRelay<ThemeColor>()
        fileprivate let tempo = PublishRelay<Double>()
        fileprivate let mainButtonTitle = PublishRelay<String>()
        fileprivate let currnetBeat = PublishRelay<Int>()
        fileprivate let onModalTransition = PublishRelay<UIViewController>()
        var themeColorEvent: Observable<ThemeColor> { return themeColor.asObservable() }
        var tempoEvent: Observable<Double> { return tempo.asObservable() }
        var mainButtonTitleEvent: Observable<String> { return mainButtonTitle.asObservable() }
        var currnetBeatEvent: Observable<Int> { return currnetBeat.asObservable() }
        var onModalTransitionEvent: Observable<UIViewController>  { return onModalTransition.asObservable() }
    }
    
    private let disposeBag = DisposeBag()
    private let metronome = Metronome()
    let viewState = ViewState()
    
    init() {
        UserInfo.shared.colorEvent
            .subscribe(onNext: { [weak self] color in
                self?.viewState.themeColor.accept(color)
            })
            .disposed(by: disposeBag)
        metronome.publishers.didStartEvent
            .subscribe(onNext: { [weak self] in
                self?.viewState.mainButtonTitle.accept("STOP")
            })
            .disposed(by: disposeBag)
        metronome.publishers.didStopEvent
            .subscribe(onNext: { [weak self] _ in
                self?.viewState.mainButtonTitle.accept("START")
            })
            .disposed(by: disposeBag)
        metronome.publishers.didChangeTempoEvent
            .subscribe(onNext: { [weak self] tempo in
                self?.viewState.tempo.accept(tempo)
            })
            .disposed(by: disposeBag)
        metronome.publishers.didBeatEvent
            .subscribe(onNext: { [weak self] beatCount in
                self?.viewState.currnetBeat.accept(beatCount)
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        viewState.themeColor.accept(LocalDataStore().themeColor)
        viewState.tempo.accept(metronome.getTempo())
    }
    
    func onTapMainButton() {
        metronome.isPlaying() ? metronome.stop() : metronome.start()
    }
    
    func stopMetronome() {
        metronome.stop()
    }
    
    func onTapPlusButton() {
        guard metronome.getTempo() < 300 else { return }
        metronome.tempoPlus1()
    }
    
    func onTapMinusButton() {
        guard metronome.getTempo() > 1 else { return }
        metronome.tempoMinus1()
    }
    
    func updateMetronomeTempo(tempo: Double) {
        metronome.setTenpo(settedTenpo: tempo)
    }
    
    func onTapTempoLabel() {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TempoSettingViewController") as! TempoSettingViewController
        VC.configure(with: Int(metronome.getTempo()), dismissed: { [weak self] tempo in
            guard let strongSelf = self else { return }
            strongSelf.updateMetronomeTempo(tempo: tempo)
        })
        viewState.onModalTransition.accept(VC)
    }
}
