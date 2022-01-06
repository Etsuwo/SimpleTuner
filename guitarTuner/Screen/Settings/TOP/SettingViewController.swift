//
//  SettingViewController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/06/25.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import XLPagerTabStrip
import MessageUI

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    private let viewModel = SettingViewModel()
    private let disposeBag = DisposeBag()
    private var mailVC: MFMailComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBind()
        viewModel.viewDidLoad()
        setup()
    }
    
    func dataBind() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.onTapTableViewCell(indexPath: indexPath)
            })
            .disposed(by: disposeBag)
        viewModel.viewState.themeColorEvent
            .map{ $0.name }
            .bind(to: colorLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.viewState.onTransitionMailEvent
            .subscribe(onNext: { [weak self] mailVC in
                self?.mailVC = mailVC
                mailVC.mailComposeDelegate = self
                self?.present(mailVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.deselectCell()
            })
            .disposed(by: disposeBag)
    }
    
    func setup() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        appVersionLabel.text = version
    }
    
    func deselectCell() {
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow else {
            return
        }
        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("##### Email send Cancelld #####")
        case .sent:
            print("##### Email sent successfully #####")
        case .failed:
            print("##### Email send faild #####")
        case .saved:
            print("##### Email saved #####")
        }
        controller.dismiss(animated: true, completion: {
            self.deselectCell()
        })
    }
}

extension SettingViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "Settings", image: UIImage(named: "cog")?.withRenderingMode(.alwaysTemplate))
        return info
    }
}
