//
//  SearchResultTableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/9.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var intervalTimeLab: UILabel!
    @IBOutlet weak var startAndEndTimeLab: UILabel!
    @IBOutlet weak var numberOfBus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
