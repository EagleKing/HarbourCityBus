//
//  BusStationV2TableViewCell.swift
//  ZJGBus
//
//  Created by EagleMan on 2016/12/27.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class BusStationV2TableViewCell: UITableViewCell {
    var isTopOrBottomCell : Bool = false // 是否是第一个 cell 或者最后一个 cell
    var busWillCome:Bool = false
    {
          willSet
          {
           
            if newValue
            {
                
                if (cellIndexPath?.row)!%2 == 0 // 是偶数,//显示到站提醒 label 在右边
                {
                    nextStationNotifyRightLab.isHidden = false
                    rightShdowLayer.isHidden = false
                    
                    nextStationNotifyLab.isHidden = true
                    leftShdowLayer.isHidden = true
                }else
                {
                    nextStationNotifyLab.isHidden = false
                    leftShdowLayer.isHidden = false
                    
                    nextStationNotifyRightLab.isHidden = true
                    rightShdowLayer.isHidden = true
                }
                
            }else
            {
             
                //不显示
                nextStationNotifyRightLab.isHidden = true
                rightShdowLayer.isHidden = true
                nextStationNotifyLab.isHidden = true
                leftShdowLayer.isHidden = true
                
            }
           }
    }
    var cellIndexPath :IndexPath?
    {
        didSet
        {
            let padding = 6
            
            if (cellIndexPath?.row)!%2 == 0 // 是偶数,显示站点名在左边
            {
                
                self.displayLabelWith(flag: true)
                leftStationNameBtn.setTitle(stationInfo?.busStationName, for: .normal)
                
                
                
                let stationName :NSString = NSString(string: (leftStationNameBtn.titleLabel?.text)!)
                let btnSize = stationName.boundingRect(with: CGSize(width:1000,height:1000), options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSFontAttributeName:leftStationNameBtn.titleLabel?.font! as Any], context: nil).size
                leftStationNameBtnCons.constant = btnSize.width + CGFloat(Float(2 * padding))
                
            }else//显示站点名在右边
            {
               
                self.displayLabelWith(flag: false)
                rightStationNameBtn.setTitle(stationInfo?.busStationName, for: .normal)
                
                
                
                //自适应 button 加约束
                let stationName :NSString = NSString(string: (rightStationNameBtn.titleLabel?.text)!)
                let btnSize = stationName.boundingRect(with: CGSize(width:1000,height:1000), options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSFontAttributeName:rightStationNameBtn.titleLabel?.font! as Any], context: nil).size
                rightStationNameBtnCos.constant = btnSize.width + CGFloat(Float(2 * padding))
                
            }
        }
    }
    
    func displayLabelWith(flag:Bool)//true 代表偶数列 false 代表奇数列
    {
        leftStationNameBtn.isHidden = !flag
        rightStationNameBtn.isHidden = flag
    }
    
    let leftShdowLayer = CALayer()
    let rightShdowLayer = CALayer()
    let normalColor = UIColor(hex: "cccccc")
    var nextStationLabColor : UIColor = UIColor(hex: "4d73ff")
    
    var stationInfo :StationInfo?
    {
        willSet
        {
        
          
        }
    }
    var flag : String?
    {
        willSet
        {
            print("\(newValue)")
            if Int(newValue!) == 1
            {
                nextStationLabColor = UIColor(hex: "4d73ff")
            }else
            {
                nextStationLabColor = UIColor(hex: "ff6172")
            }
        }
    }
    
    @IBOutlet weak var leftStationNameBtn: UIButton! //显示在左边的站点名称
    @IBOutlet weak var leftStationNameBtnCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var rightStationNameBtn: UIButton! //显示在右边的站点名称
    @IBOutlet weak var rightStationNameBtnCos: NSLayoutConstraint!
    
    
    @IBOutlet weak var nextStationNotifyLab: UILabel! //显示在左边的下站抵达
    @IBOutlet weak var nextStationNotifyRightLab: UILabel! //显示在右边的下站抵达
    
    let centerLabel = UILabel() //中间的显示标签
    
    
    @IBAction func leftStationBtnClick(_ sender: UIButton)
    {}
    
 
    @IBAction func rightStationBtnClick(_ sender: UIButton)
    {}
    
 
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        nextStationNotifyRightLab.isHidden = false
        rightShdowLayer.isHidden = false
        nextStationNotifyLab.isHidden = false
        leftShdowLayer.isHidden = false
        
        centerLabel.clipsToBounds = true
        self.contentView.addSubview(centerLabel)
        
        
        rightStationNameBtn.titleLabel?.textAlignment = .center
        leftStationNameBtn.titleLabel?.textAlignment = .center
    
        
        //给标签加效果
        leftShdowLayer.shadowOffset = CGSize(width: 0, height: 3)
        leftShdowLayer.shadowOpacity = 0.7
        
        leftShdowLayer.cornerRadius = 3
        self.contentView.layer.insertSublayer(leftShdowLayer, below: nextStationNotifyLab.layer)
        nextStationNotifyLab.layer.cornerRadius = 3
        nextStationNotifyLab.layer.masksToBounds = true
        
        rightShdowLayer.shadowOffset = CGSize(width: 0, height: 3)
        rightShdowLayer.shadowOpacity = 0.7
        
        rightShdowLayer.cornerRadius = 3
        self.contentView.layer.insertSublayer(rightShdowLayer, below: nextStationNotifyRightLab.layer)
        
        nextStationNotifyRightLab.layer.cornerRadius = 3
        nextStationNotifyRightLab.layer.masksToBounds = true
        
        let borderColor = UIColor(hex: "888888")
        rightStationNameBtn.layer.cornerRadius = 3
        rightStationNameBtn.layer.borderWidth = 0.5
        rightStationNameBtn.layer.borderColor = borderColor.cgColor
        
        leftStationNameBtn.layer.cornerRadius = 3
        leftStationNameBtn.layer.borderWidth = 0.5
        leftStationNameBtn.layer.borderColor = borderColor.cgColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func draw(_ rect: CGRect)
    {
        //根据上下行配置颜色
        nextStationNotifyLab.backgroundColor = nextStationLabColor
        leftShdowLayer.backgroundColor = nextStationLabColor.cgColor
        leftShdowLayer.shadowColor = nextStationLabColor.cgColor
        
        nextStationNotifyRightLab.backgroundColor = nextStationLabColor
        rightShdowLayer.backgroundColor = nextStationLabColor.cgColor
        rightShdowLayer.shadowColor = nextStationLabColor.cgColor
        
        let normalWidth :CGFloat = 8
        
        //配置中间的原点标签
        centerLabel.frame = CGRect(x: 0, y: 0, width:normalWidth*1.3, height:normalWidth * 1.3)
        centerLabel.center = self.contentView.center
        centerLabel.backgroundColor = normalColor
        centerLabel.layer.cornerRadius = centerLabel.frame.size.width/2
        centerLabel.layer.borderColor = UIColor.white.cgColor
        centerLabel.layer.borderWidth = 2.5
        
        
        //对齐阴影图层
        leftShdowLayer.frame = self.nextStationNotifyLab.frame
        rightShdowLayer.frame = self.nextStationNotifyRightLab.frame
    
        
        if busWillCome
        {
            
            var linkLinePath : UIBezierPath?
            if (cellIndexPath?.row)!%2 == 0 // 是偶数,//显示到站提醒 label 在右边
            {
               //绘制在左边
               linkLinePath = UIBezierPath(rect: CGRect(x:centerLabel.center.x, y: centerLabel.center.y, width: centerLabel.center.x - nextStationNotifyLab.frame.minX, height: 1))
                nextStationLabColor.setFill()
                linkLinePath?.fill()
                centerLabel.backgroundColor = nextStationLabColor
            
                
            }else
            {
                
                //绘制在右边
                linkLinePath = UIBezierPath(rect: CGRect(x:nextStationNotifyLab.frame.maxX, y: nextStationNotifyLab.center.y, width: centerLabel.center.x - nextStationNotifyLab.frame.maxX, height: 1))
                nextStationLabColor.setFill()
                linkLinePath?.fill()
                
                centerLabel.backgroundColor = nextStationLabColor
           
                
            }
        }else
        {
            centerLabel.backgroundColor = normalColor
     
        }
        
        if isTopOrBottomCell //是第一个 cell
        {
            
            centerLabel.frame = CGRect(x: 0, y: 0, width:normalWidth, height:normalWidth)
            centerLabel.center = self.contentView.center
            centerLabel.layer.cornerRadius = centerLabel.frame.size.width/2
            if busWillCome
            {
                if (cellIndexPath?.row)!%2 == 0
                {
                    centerLabel.backgroundColor = nextStationLabColor
                    centerLabel.layer.borderColor  = nextStationLabColor.cgColor
                }else
                {
                    centerLabel.backgroundColor = nextStationLabColor
                    centerLabel.layer.borderColor  = nextStationLabColor.cgColor
                }
            }else
            {
                centerLabel.backgroundColor = UIColor(hex: "7b7b7b")
                centerLabel.layer.borderColor  = UIColor(hex: "7b7b7b").cgColor
            }
            
            
            
            
            centerLabel.layer.borderWidth = 0
            
            if cellIndexPath?.row == 0
            {
                let rectanglePath = UIBezierPath(rect: CGRect(x:self.frame.width/2 - CGFloat(normalWidth/2), y:self.contentView.frame.size.height/2, width:CGFloat(normalWidth), height: self.contentView.frame.size.height/2 ))
                normalColor.setFill()
                rectanglePath.fill()
            }else
            {
                let rectanglePath = UIBezierPath(rect: CGRect(x:self.frame.width/2 - CGFloat(normalWidth/2), y:0 , width:CGFloat(normalWidth), height: self.contentView.frame.size.height/2 ))
                normalColor.setFill()
                rectanglePath.fill()
            }
            
        }else // 中间 cell
        {
            let rectanglePath = UIBezierPath(rect: CGRect(x:self.frame.width/2 - CGFloat(normalWidth/2), y:0 , width:CGFloat(normalWidth), height: self.contentView.frame.size.height ))
            normalColor.setFill()
            rectanglePath.fill()
        }
      
    }
}
