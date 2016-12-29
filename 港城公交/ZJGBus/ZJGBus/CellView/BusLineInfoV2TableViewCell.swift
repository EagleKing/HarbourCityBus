//
//  BusLineInfoV2TableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 2016/12/14.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import SnapKit
class BusLineInfoV2TableViewCell: UITableViewCell {

    @IBOutlet weak var intervalLab: UILabel!
    @IBOutlet weak var startStationLab: UILabel!//首站
    @IBOutlet weak var endStationLab: UILabel!//末战
    @IBOutlet weak var runPathName: UILabel!
    @IBOutlet weak var changeDirectionBtn: UIButton!//点击改变方向
    @IBOutlet weak var IntervalCarContainerView: UIView!//显示首末班的区间时间容器视图
    var timeLabs : [UILabel]?
    var displayedTimeLabs :[UILabel]? // 当前展示在 cell 上的时间标签
    
    
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
    
    var busInfos = [BusInfoWithRunPathID]()//指定公交车详细信息，两个元素，分别为上下行
    {
        didSet
        {
             self.changeDirectionBtn.isSelected = false
             self.configureUIWithIndex(arrIndex: 0)
        }
    }
    @IBAction func changeDirection(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        //移除视图，赋值相应的数据源
        if sender.isSelected
        {
            self.configureUIWithIndex(arrIndex: 1)
        }else
        {
            self.configureUIWithIndex(arrIndex: 0)
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 3
        self.layer.shadowOffset =  CGSize(width: 0.0, height: 2)
        self.layer.shadowColor = UIColor.ColorHex(hex: "f0f0f0").cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        
        self.IntervalCarContainerView.layer.cornerRadius = 3
        timeLabs = Array(repeating: UILabel(), count: 6)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureUIWithIndex(arrIndex:Int)
    {
        if (displayedTimeLabs?.count) != nil
        {
            for displayTimeLab in displayedTimeLabs!
            {
                displayTimeLab.removeFromSuperview()
            }
        }
        
        
        var busInfoWithRunPathID:BusInfoWithRunPathID
        
        //这里区分方向
        if arrIndex >= 1
        {
            busInfoWithRunPathID  = busInfos[1]
        }else
        {
            busInfoWithRunPathID  = busInfos[0]
        }
        
        startStationLab.text = busInfoWithRunPathID.startStation
        endStationLab.text  = busInfoWithRunPathID.endStation
        runPathName.text = busInfoWithRunPathID.runPathName
        
        //取出startTime
        let startTime = busInfoWithRunPathID.startTime
        let startTimes =  startTime.components(separatedBy: CharacterSet.init(charactersIn: ","))//按逗号分隔发车时间
        let timeLabMargin = 8
        
        //判断是区间车还是正常的公交车
        if startTimes.count != 1 //区间车
        {
            
            IntervalCarContainerView.backgroundColor = UIColor(hex: "777777")
            intervalLab.isHidden = false
            timeLabs = [UILabel]()//初始化数组
            
            for _ in startTimes
            {
                timeLabs?.append(UILabel())
            }
            
            displayedTimeLabs = timeLabs
            for (index,timeLab) in (timeLabs?.enumerated())!
            {
            
                
                timeLab.textColor = UIColor.white
                
                
                //获取苹方字体
                timeLab.font = UIFont.init(name: UIFont.fontNames(forFamilyName:"PingFang SC")[1], size:12.0)
                // timeLab.font = UIFont.systemFont(ofSize: 12.0)
                timeLab.text = startTimes[index]
                
                IntervalCarContainerView.addSubview(timeLab)
                
                if index == 0 || index == 2 || index == 4 //第一列
                {
                    
                    if index ==  0//这个标签上边缘和区间车标签对齐
                    {
                        timeLab.snp.makeConstraints({ (maker) in
                            maker.top.equalTo(intervalLab.snp.bottom).offset(timeLabMargin)
                            maker.left.equalTo(IntervalCarContainerView.snp.left).offset(timeLabMargin)
                    })
                        
                }else//这个标签的上边缘和上个标签对齐
                {
                        
                        timeLab.snp.makeConstraints({ (maker) in
                            maker.top.equalTo((timeLabs?[index - 2].snp.bottom)!).offset(timeLabMargin)
                            maker.left.equalTo(IntervalCarContainerView.snp.left).offset(timeLabMargin)
                })
                        
                }
                    
                }else if index == 1 || index == 3 || index == 5 //第二列
                {
                    if index == 1
                    {
                        timeLab.snp.makeConstraints({ (maker) in
                            maker.top.equalTo(intervalLab.snp.bottom).offset(timeLabMargin)
                            maker.right.equalTo(IntervalCarContainerView.snp.right).offset(-(timeLabMargin))
                        })
                    }else
                    {
                        
                        timeLab.snp.makeConstraints({ (maker) in
                            maker.top.equalTo((timeLabs?[index - 2].snp.bottom)!).offset(timeLabMargin)
                            maker.right.equalTo(IntervalCarContainerView.snp.right).offset(-(timeLabMargin))
                        })
                        
                    }
                }
            }
            
            
        }else//非区间车
        {
            
            IntervalCarContainerView.backgroundColor = UIColor(hex:"fb4760")
            intervalLab.isHidden = true
            
            for timeLab in timeLabs!
            {
                timeLab.removeFromSuperview()
            }
            
            timeLabs = [UILabel]()
            let startTimeLab = UILabel()
            startTimeLab.font = UIFont.init(name: UIFont.fontNames(forFamilyName:"PingFang SC")[1], size:12.0)
            startTimeLab.text  = "早班"+busInfoWithRunPathID.startTime
            startTimeLab.textColor = UIColor.white
            timeLabs?.append(startTimeLab)
            IntervalCarContainerView.addSubview(startTimeLab)
            startTimeLab.snp.makeConstraints({ (maker) in
                maker.top.equalTo(IntervalCarContainerView.snp.top).offset(10)
                maker.centerX.equalTo(IntervalCarContainerView.snp.centerX)
            })
            
            let endTimeLab = UILabel()
            endTimeLab.font = UIFont.init(name: UIFont.fontNames(forFamilyName:"PingFang SC")[1], size:12.0)
            endTimeLab.text  = "晚班"+busInfoWithRunPathID.startTime
            endTimeLab.textColor = UIColor.white
            timeLabs?.append(endTimeLab)
            IntervalCarContainerView.addSubview(endTimeLab)
            endTimeLab.snp.makeConstraints({ (maker) in
                maker.centerX.equalTo(IntervalCarContainerView.snp.centerX)
                maker.centerY.equalTo(IntervalCarContainerView.snp.centerY)
            })
            
            let intervalTimeLab = UILabel()
            intervalTimeLab.font = UIFont.init(name: UIFont.fontNames(forFamilyName:"PingFang SC")[1], size:12.0)
            intervalTimeLab.text  = "间隔"+busInfoWithRunPathID.busInterval
            intervalTimeLab.textColor = UIColor.white
            timeLabs?.append(intervalTimeLab)
            IntervalCarContainerView.addSubview(intervalTimeLab)
            intervalTimeLab.snp.makeConstraints({ (maker) in
                maker.centerX.equalTo(IntervalCarContainerView.snp.centerX)
                maker.bottom.equalTo(IntervalCarContainerView.snp.bottom).offset(-10)
            })
            displayedTimeLabs = timeLabs
            
        }
    }
}
