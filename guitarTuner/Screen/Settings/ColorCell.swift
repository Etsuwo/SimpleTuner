//
//  ColorCell.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2021/01/22.
//  Copyright © 2021 大谷悦志. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var mainColorView: UIView!
    @IBOutlet weak var subColorView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    static let identifier = "ColorCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupView()
    }
    
    func setupView() {
        let cornerRadius = mainColorView.frame.height / 4
        cardView.cardView()
        mainColorView.layer.cornerRadius = cornerRadius
        subColorView.layer.cornerRadius = cornerRadius
    }
}
