//
//  BusStationTableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/11.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class BusStationTableViewCell: UITableViewCell {

    @IBOutlet weak var stationLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func draw(_ rect: CGRect) {
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 14.5, y: 23.5, width: 12, height: 12))
        UIColor.white.setFill()
        ovalPath.fill()
        UIColor.init(hex:UniversalColorHexString).setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20.5, y: -0.5))
        bezierPath.addLine(to: CGPoint(x: 20.5, y: 23.5))
        UIColor.init(hex: "#888888").setStroke()
        bezierPath.lineWidth = 4
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 20.5, y: 35.5))
        bezier2Path.addLine(to: CGPoint(x: 20.5, y: 59.5))
        UIColor.init(hex: "#888888").setStroke()
        bezier2Path.lineWidth = 4
        bezier2Path.stroke()
    }
}
