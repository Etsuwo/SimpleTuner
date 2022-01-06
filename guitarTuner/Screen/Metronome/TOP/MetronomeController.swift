//
//  MetronomeController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/08/24.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import XLPagerTabStrip

class MetronomeController: UIViewController {
    
    @IBOutlet weak var tempoView: UnderLineView!
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var metroCountView: MetroCountView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tempoLabelTapGestureRecognizer: UITapGestureRecognizer!
    
    private let viewModel = MetronomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.isUserInteractionEnabled = true
        dataBind()
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = self.initViewLayout
    }
    
    private lazy var initViewLayout : Void = {
        metroCountView.makeView()
        setupUIs()
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopMetronome()
        metroCountView.refresh()
    }
    
    func setupUIs() {
        startButton.layer.borderColor = UIColor.gray.cgColor
        startButton.layer.borderWidth = 1.0
        startButton.layer.cornerRadius = startButton.frame.height / 4
        startButton.setTitle("START", for: .normal)
    }
    
    func dataBind() {
        viewModel.viewState.themeColorEvent
            .subscribe(onNext: { [weak self] color in
                self?.tempoView.lineColor = color.main
                self?.metroCountView.color = color
            })
            .disposed(by: disposeBag)
        viewModel.viewState.tempoEvent
            .map{ String(format: "%.0f", $0) }
            .bind(to: tempoLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.viewState.mainButtonTitleEvent
            .subscribe(onNext: { [weak self] title in
                self?.startButton.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)
        viewModel.viewState.currnetBeatEvent
            .subscribe(onNext: { [weak self] beatCount in
                self?.metroCountView.circleLighting(beatCount: beatCount)
            })
            .disposed(by: disposeBag)
        viewModel.viewState.onModalTransitionEvent
            .subscribe(onNext: { [weak self] VC in
                self?.present(VC, animated: true)
            })
            .disposed(by: disposeBag)
        startButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onTapMainButton()
            })
            .disposed(by: disposeBag)
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onTapPlusButton()
            })
            .disposed(by: disposeBag)
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onTapMinusButton()
            })
            .disposed(by: disposeBag)
        tempoLabelTapGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onTapTempoLabel()
            })
            .disposed(by: disposeBag)
    }
}

extension MetronomeController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "Metro", image: UIImage(named: "metronome")?.withRenderingMode(.alwaysTemplate))
        return info
    }
}

