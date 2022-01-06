//
//  underLineView.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2021/02/05.
//  Copyright © 2021 大谷悦志. All rights reserved.
//

import UIKit

class UnderLineView: UIView {
    
    private let line = UIView()
    private let lineWidth: CGFloat = 2
    var lineColor: UIColor = UIColor.clear {
        didSet {
            line.backgroundColor = lineColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawUnderLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawUnderLine()
    }
    
    private func drawUnderLine() {
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: lineWidth).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
