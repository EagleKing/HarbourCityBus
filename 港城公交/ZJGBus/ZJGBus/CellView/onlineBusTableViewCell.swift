//
//  onlineBusTableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/12.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class onlineBusTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var currentStationLab: UILabel!
    @IBOutlet weak var plateNoLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
