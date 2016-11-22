//
//  BusLineInfoTableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/9.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class BusLineInfoTableViewCell: UITableViewCell {
    var BusInfo:BusInfoWithRunPathID = BusInfoWithRunPathID()
    {
        didSet
        {
           //公交间隔
           intervalTimeLab.text = BusInfo.busInterval + "分钟"
            //开始站点
            startStationLab.text = BusInfo.startStation
            //终点站
            endStationLab.text = BusInfo.endStation
            //开始结束时间
            startAndEndTimeLab.text = BusInfo.startTime + "~" + BusInfo.endTime
            //
            runPathNameLab.text = BusInfo.runPathName
        
        }
    }
    @IBOutlet weak var intervalTimeLab: UILabel!
    @IBOutlet weak var startAndEndTimeLab: UILabel!
    @IBOutlet weak var runPathNameLab: UILabel!
    @IBOutlet weak var endStationLab: UILabel!
    @IBOutlet weak var startStationLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
