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
    
    override var frame: CGRect
    {
        didSet
        {
            var newFrame = frame
            newFrame.origin.x = 7.5
            newFrame.size.width -= 20
            newFrame.size.height -= 15
            newFrame.origin.y += 10
            super.frame = newFrame//访问超类版本的 frame 属性不会引起子类的属性观察器
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.shadowOffset =  CGSize(width: 0.0, height: 2)
        self.layer.shadowColor = UIColor.ColorHex(hex: "f0f0f0").cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
