//
//  TabBarController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2020/12/03.
//  Copyright © 2020 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift
import XLPagerTabStrip

class TabBarController: BaseButtonBarPagerTabStripViewController<TabbarCell> {
    
    var themeColor: ThemeColor = .blue
    var isInitBind: Bool = true
    let iconDisabledColor = UIColor.gray
    let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonBarItemSpec = ButtonBarItemSpec.nibFile(nibName: "TabbarCell", bundle: Bundle(for: TabbarCell.self), width: {
            _ in
            return 64
        })
    }
    
    override func viewDidLoad() {
        if isInitBind {
            dataBind()
        }
        tabBarSetting()
        super.viewDidLoad()
    }
    
    func dataBind() {
        UserInfo.shared.colorEvent.subscribe(onNext: {
            color in
            self.themeColor = color
            if self.isInitBind {
                self.isInitBind = false
            } else {
                self.reLoadView()
            }
        }).disposed(by: disposeBag)
    }
    
    //テーマカラーの更新用
    func reLoadView() {
        loadView()
        viewDidLoad()
    }
    
    func tabBarSetting() {
        settings.style.buttonBarBackgroundColor = UIColor.mainBackground
        settings.style.buttonBarItemBackgroundColor = UIColor.mainBackground
        settings.style.selectedBarBackgroundColor = UIColor.clear
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarRightContentInset = 20
        settings.style.buttonBarLeftContentInset = 20
        changeCurrentIndexProgressive = { [weak self] (
            oldCell: TabbarCell?, newCell: TabbarCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard let oldCell = oldCell, let newCell = newCell else {
                return
            }
            oldCell.iconImageView.tintColor = self?.iconDisabledColor
            oldCell.iconLabel.textColor = self?.iconDisabledColor
            newCell.iconImageView.tintColor = self?.themeColor.sub
            newCell.iconLabel.textColor = self?.themeColor.sub
            self?.navigationItem.title = newCell.iconLabel.text
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC1 = storyboard.instantiateViewController(identifier: "TunerViewController") as! TunerViewController
        let VC2 = storyboard.instantiateViewController(identifier: "MetronomeController") as! MetronomeController
        let VC3 = storyboard.instantiateViewController(identifier: "VolumeMaterViewController") as! VolumeMaterViewController
        let VC4 = storyboard.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        let childViewControllers: [UIViewController] = [VC1, VC2, VC3, VC4]
        
        return childViewControllers
    }
    
    override func configure(cell: TabbarCell, for indicatorInfo: IndicatorInfo) {
        cell.iconImageView.tintColor = iconDisabledColor
        cell.iconImageView.image = indicatorInfo.image?.withRenderingMode(.alwaysTemplate)
        cell.iconLabel.textColor = iconDisabledColor
        cell.iconLabel.text = indicatorInfo.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        if cell.isSelected {
            cell.iconImageView.tintColor = themeColor.sub
            cell.iconLabel.textColor = themeColor.sub
            self.navigationItem.title = cell.iconLabel.text
        }
    }
}
