//
//  VolumeMeterViewModel.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/02.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class VolumeMeterViewModel {
    
    struct ViewState {
        fileprivate let themeColor = PublishRelay<ThemeColor>()
        fileprivate let amplitude = PublishRelay<Double>()
        var themeColorEvent: Observable<ThemeColor> { return themeColor.asObservable() }
        var amplitudeEvent: Observable<Double> { return amplitude.asObservable() }
    }
    
    private let disposeBag = DisposeBag()
    private let volumeMeter = VolumeMeter()
    let viewState = ViewState()
    
    init() {
        UserInfo.shared.colorEvent
            .subscribe(onNext: { [weak self] color in
                self?.viewState.themeColor.accept(color)
            })
            .disposed(by: disposeBag)
        volumeMeter.volumeMeterPublisher
            .subscribe(onNext: { [weak self] amplitude in
                let amplitude = amplitude < 0 ? 0 : amplitude
                self?.viewState.amplitude.accept(amplitude)
            })
            .disposed(by: disposeBag)
            
    }
    
    func viewDidLoad() {
        viewState.themeColor.accept(LocalDataStore().themeColor)
    }
    
    func startVolumeMeter() {
        volumeMeter.analyzer.start()
    }
    
    func stopVolumeMeter() {
        volumeMeter.analyzer.stop()
    }
}
