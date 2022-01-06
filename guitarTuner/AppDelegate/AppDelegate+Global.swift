//
//  AppDelegate+Global.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2022/01/06.
//  Copyright © 2022 大谷悦志. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension AppDelegate {
    
    func observeThemeColorChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupAppNavigationController), name: .didChangeThemeColor, object: nil)
    }
    
    @objc func setupAppNavigationController() {
        let color = LocalDataStore().themeColor.tab
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = color
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}
