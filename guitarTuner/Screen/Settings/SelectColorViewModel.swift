//
//  SelectColorViewModel.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/03.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class SelectColorViewModel {
    
    struct ViewState {
        fileprivate let themeColor = BehaviorRelay<ThemeColor>(value: .blue)
        var themeColorEvent: Observable<ThemeColor> { return themeColor.asObservable() }
    }
    
    private let disposeBag = DisposeBag()
    let viewState = ViewState()
    var themeColor: ThemeColor {
        viewState.themeColor.value
    }
    
    init() {
        UserInfo.shared.colorEvent
            .subscribe(onNext: { [weak self] color in
                self?.viewState.themeColor.accept(color)
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        viewState.themeColor.accept(LocalDataStore().themeColor)
    }
    
    func onTapTableViewCell(indexPath: IndexPath) {
        guard let color = ThemeColor.init(rawValue: indexPath.row) else { return }
        UserInfo.shared.setColor(color: color)
    }
}
