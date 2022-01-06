//
//  SettingViewModel.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/03.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import MessageUI

final class SettingViewModel {
    
    struct ViewState {
        fileprivate let themeColor = PublishRelay<ThemeColor>()
        fileprivate let onTransitionMail = PublishRelay<MFMailComposeViewController>()
        var themeColorEvent: Observable<ThemeColor> { return themeColor.asObservable() }
        var onTransitionMailEvent: Observable<MFMailComposeViewController> { return onTransitionMail.asObservable() }
    }
    
    private let disposeBag = DisposeBag()
    let viewState = ViewState()
    
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
        switch indexPath.section {
        case SettingTableSections.others.rawValue:
            settingTableAction(row: indexPath.row)
        default: break
        }
    }
    
    private func settingTableAction(row: Int) {
        switch row {
        case SettingTableSections.OthersSection.review.rawValue:
            guard let reviewURL = URL(string: "https://apps.apple.com/app/id1563149768?action=write-review") else {
                return
            }
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        case SettingTableSections.OthersSection.feedback.rawValue:
            guard let mailVC = MFMailComposeViewController.feedBackMailViewController() else {
                return
            }
            viewState.onTransitionMail.accept(mailVC)
        default: break
        }
    }
}
