//
//  UIAlertController.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/16.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func makeForceUpdateAlert(latestVersion: String, storeUrl: URL) -> UIAlertController {
        let controller = UIAlertController(title: "新しいバージョンのアプリが公開されました！", message: "現在の最新バージョンは: \(latestVersion)です。安定稼働のため、アプリストアでの更新をよろしくお願いします。", preferredStyle: .alert)
        let action = UIAlertAction(title: "アプリストアへ", style: .default) { _ in
            UIApplication.shared.open(storeUrl)
        }
        controller.addAction(action)
        return controller
    }
}
