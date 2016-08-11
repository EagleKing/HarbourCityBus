//
//  BusStationTableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/11.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class BusStationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func drawRect(rect: CGRect) {
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalInRect: CGRectMake(14.5, 23.5, 12, 12))
        UIColor.whiteColor().setFill()
        ovalPath.fill()
        UIColor.init(hex:UniversalColorHexString).setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(20.5, -0.5))
        bezierPath.addLineToPoint(CGPointMake(20.5, 23.5))
        UIColor.init(hex: "#888888").setStroke()
        bezierPath.lineWidth = 4
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPointMake(20.5, 35.5))
        bezier2Path.addLineToPoint(CGPointMake(20.5, 59.5))
        UIColor.init(hex: "#888888").setStroke()
        bezier2Path.lineWidth = 4
        bezier2Path.stroke()
    }
}
