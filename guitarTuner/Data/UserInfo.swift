//
//  User.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2021/01/06.
//  Copyright © 2021 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class UserInfo {
    
    static let shared = UserInfo()
    private let localDataStore = LocalDataStore()
    
    private init() {
        self.color.accept(localDataStore.themeColor)
        self.baseFrequency.accept(localDataStore.baseFrequency)
    }
    
    private let color = BehaviorRelay<ThemeColor>(value: .blue)
    private let baseFrequency = BehaviorRelay<Double>(value: 440)
    private let tempo = BehaviorRelay<Double>(value: 120)
    
    var colorEvent: Observable<ThemeColor> { return color.asObservable() }
    var baseFrequencyEvent: Observable<Double> { return baseFrequency.asObservable() }
    var tempoEvent: Observable<Double> { return tempo.asObservable() }
    
    func setColor(color: ThemeColor) {
        localDataStore.themeColor = color
        self.color.accept(color)
    }
    
    func setBaseFrequency(baseFrequency: Double) {
        self.baseFrequency.accept(baseFrequency)
        localDataStore.baseFrequency = baseFrequency
    }
    
    func setTempo(tempo: Double) {
        self.tempo.accept(tempo)
    }
}
