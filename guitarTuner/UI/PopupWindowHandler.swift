//
//  PopupWindowHandler.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/16.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation
import UIKit

final class PopupWindowHandler<T: UIViewController> {
    private let window: UIWindow = {
        let window = UIWindow()
        window.backgroundColor = .clear
        return window
    }()
    
    func show(viewController: T) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func dismiss() {
        window.isHidden = true
    }
}
