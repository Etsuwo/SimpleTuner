//
//  VolumeMaterViewController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2020/11/28.
//  Copyright © 2020 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift
import XLPagerTabStrip

class VolumeMaterViewController: UIViewController {
    
    @IBOutlet weak var volumeMeterBarView: VolumeMeterBarView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelView: UnderLineView!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitLableView: UnderLineView!
    
    private let viewModel = VolumeMeterViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsLogger.shared.logScreenView(screen: .volumeMeter)
        viewModel.startVolumeMeter()
    }
    
    func dataBind() {
        viewModel.viewState.themeColorEvent
            .subscribe(onNext: { [weak self] color in
                self?.titleLabelView.lineColor = color.main
                self?.unitLableView.lineColor = color.main
                self?.volumeMeterBarView.soundBarColor = color.sub
            })
            .disposed(by: disposeBag)
        viewModel.viewState.amplitudeEvent
            .subscribe(onNext: { [weak self] amplitude in
                self?.amplitudeLabel.text = String(format: "%.0f", amplitude)
                self?.volumeMeterBarView.lightingSoundbars(amplitude: amplitude)
            })
            .disposed(by: disposeBag)
    }
}

extension VolumeMaterViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "Volume", image: UIImage(named: "volume")?.withRenderingMode(.alwaysTemplate))
        return info
    }
}
