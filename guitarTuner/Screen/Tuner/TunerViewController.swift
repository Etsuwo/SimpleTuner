//
//  ViewController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/04/05.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxRelay
import RxCocoa

class TunerViewController: UIViewController {

    @IBOutlet weak var baseFrequencyLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var pitchTitleLabel: UILabel!
    @IBOutlet weak var frequencyTitleLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var pitchView: UnderLineView!
    @IBOutlet weak var frequencyView: UnderLineView!
    @IBOutlet weak var noteView: UnderLineView!
    @IBOutlet weak var materBaseView: UIView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private let viewModel = TunerViewModel()
    var scaleAffine: CGAffineTransform?
    let lineWidth: CGFloat = 2
    let disposeBag = DisposeBag()
    let materView = MaterView()
    let arrowView = ArrowView()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = self.initViewLayout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startTuner()
    }
    
    private lazy var initViewLayout : Void = {
        setupUIs()
    }()
    
    func dataBind() {
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
        viewModel.viewState.themeColorEvent
            .subscribe(onNext: { [weak self] color in
                self?.noteView.lineColor = color.main
                self?.pitchView.lineColor = color.main
                self?.frequencyView.lineColor = color.main
            })
            .disposed(by: disposeBag)
        viewModel.viewState.baseFrequencyEvent
            .map{ String(format: "%.0f", $0) + "Hz" }
            .bind(to: baseFrequencyLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.viewState.pitchFrequencyEvent
            .map{ String(format: "%.1f", $0) }
            .bind(to: pitchLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.viewState.frequencyEvent
            .map{ String(format: "%.1f", $0) }
            .bind(to: frequencyLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.viewState.noteEvent
            .map{ "\($0)" }
            .bind(to: noteLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.viewState.onMoveArrowViewEvent
            .subscribe(onNext: { [weak self] (pitch, frequency) in
                guard let scaleAffine = self?.scaleAffine else {
                    return
                }
                self?.arrowView.moveArrowLayer(pitch: pitch, frequency: frequency, scaleAffine: scaleAffine)
            })
            .disposed(by: disposeBag)
    }
   
    func setupUIs() {
        //labels
        noteTitleLabel.text = "Note"
        pitchTitleLabel.text = "Pitch"
        frequencyTitleLabel.text = "Frequency"
        
        //views
        scaleAffine = CGAffineTransform(scaleX: 1.1, y: 1)
        materView.frame.size = CGSize(width: materBaseView.frame.width, height: materBaseView.frame.width)
        materView.center = CGPoint(x: materBaseView.center.x, y: materBaseView.frame.height)
        materView.makeMaterView()
        self.view.addSubview(materView)
        self.view.sendSubviewToBack(materView)
        arrowView.frame.size = CGSize(width: materBaseView.frame.width, height: materBaseView.frame.width)
        arrowView.center = CGPoint(x: materBaseView.center.x, y: materBaseView.frame.height)
        arrowView.makeArrowLayer()
        self.view.addSubview(arrowView)
        self.view.sendSubviewToBack(arrowView)
    }
}

extension TunerViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "Tuner", image: UIImage(named: "tuningFork")?.withRenderingMode(.alwaysTemplate))
        return info
    }
}
