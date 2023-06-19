//
//  SelectColorViewController.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2021/01/22.
//  Copyright © 2021 大谷悦志. All rights reserved.
//

import UIKit
import RxSwift

class SelectColorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SelectColorViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dataBind()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsLogger.shared.logScreenView(screen: .selectColor)
    }
    
    func dataBind() {
        viewModel.viewState.themeColorEvent
            .subscribe(onNext: { [weak self] color in
                self?.navigationController?.navigationBar.updateColorAppearance(color: color.tab)
                self?.tableView.reloadData()
                FirebaseAnalyticsLogger.shared.log(event: AnalyticsSelectContent(contentName: AnalyticsContentName.selectThemeColor, contentParameters: [AnalyticsThemeColor(themeColor: color)]))
            })
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.onTapTableViewCell(indexPath: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ColorCell.identifier, bundle: nil), forCellReuseIdentifier: ColorCell.identifier)
        tableView.dataSource = self
    }
}

extension SelectColorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThemeColor.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColorCell.identifier, for: indexPath) as! ColorCell
        guard let color = ThemeColor.init(rawValue: indexPath.row) else {
            return cell
        }
        cell.checkImageView.isHidden = indexPath.row != viewModel.themeColor.rawValue
        cell.colorLabel.text = color.name
        cell.mainColorView.backgroundColor = color.main
        cell.subColorView.backgroundColor = color.sub
        return cell
    }
}

extension NSObject {
    class var className: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    var className: String {
        type(of: self).className
    }
}
