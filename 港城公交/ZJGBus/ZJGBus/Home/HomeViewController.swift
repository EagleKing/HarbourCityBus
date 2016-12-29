//
//  HomeViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 2016/12/12.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

let SHOWSEARCHRESULTNOTIFICATION = "showSearchResultNotification"

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate
{
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    @IBOutlet weak var startTimeLab: UILabel! // 首发时间
    @IBOutlet weak var endTimeLab: UILabel! //结束时间
    @IBOutlet weak var busTimeInterval: UILabel! //发车间隔
    
    
    
    var animator: ZFModalTransitionAnimator?
    var collections : [BusOnlineEntity]?
    let shadowLayer = CALayer()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        self.homeTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //没有收藏的时候默认的背景
        let backgroundImageView = UIImageView(image:#imageLiteral(resourceName: "HomeTBBac"))
        backgroundImageView.contentMode = .scaleToFill
        self.homeTableView.backgroundView = backgroundImageView
        self.homeTableView.layer.cornerRadius = 4
        self.homeTableView.layer.masksToBounds = true

        self.view.layer.insertSublayer(shadowLayer, below: self.homeTableView.layer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(showBusOnlineInfo(notification:)), name: NSNotification.Name(rawValue: SHOWSEARCHRESULTNOTIFICATION), object: nil)
        
        let busStationV2CellID = "busStationV2CellID"
        homeTableView.register(UINib(nibName:"BusStationV2TableViewCell",bundle:nil), forCellReuseIdentifier: busStationV2CellID)
        
    }
    var busAllstation = BusAllStationEntity()
        {
        didSet
        {
            homeTableView.reloadData()
        }
    }
    var busOnlineLists = [BusOnlineInfo]()
        {
        didSet
        {
            //先去掉所有的 true
            for uniDataSource in busAllstation.currentLines
            {
                uniDataSource.isStation = true
            }
            
            let stationNameCount = busAllstation.currentLines.count
            let currentLines = busAllstation.currentLines
            
            
            for currentBusEntity in busOnlineLists
            {
                for i in 0 ..< stationNameCount
                {
                    print(i)
                    print("\(currentBusEntity.busStationName ) ++++++++ \((busAllstation.currentLines[i]).stationInfo?.busStationName)")
                    
                    if let busStationName = (busAllstation.currentLines[i]).stationInfo?.busStationName
                    {
                        
                         if currentBusEntity.busStationName == busStationName
                         {
                            (busAllstation.currentLines[i]).busOnlineInfo = currentBusEntity
                            (busAllstation.currentLines[i]).isStation = false
                         }
                        
                     }

                }
            }
            self.busAllstation.currentLines = currentLines
            
            homeTableView.reloadData()
        }
    }
    
    @IBOutlet weak var changeDirectionBtn: UIButton!
    
    @IBAction func changeDirection(_ sender:  UIButton)
    {
        busOnlineRequestTimer?.invalidate()
         sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            currentIndex = 1
        }else
        {
            currentIndex = 0
        }
        self.getBusLineInfo()
    }
    
    let flags = ["1","3"]
    var runPathID = ""
    var currentIndex = 0
    var busInfo : BusInfoWithRunPathID?
    var busInfos : [BusInfoWithRunPathID]?
    
     let busStationV2CellID = "busStationV2CellID"
    
    var busOnlineRequestTimer : Timer?
    func busOnlineRequest()
    {
        print("\(Date())")
        BusOnlineEntity.startRequestWith(self.runPathID, flag:self.flags[self.currentIndex], completionHandler:
            { (dataModel) in
                print(self.busAllstation.currentLines.count)
                if (dataModel?.lists?.count != 0)
                {
                    
                    
                  
                    self.busOnlineLists = (dataModel?.lists!)!//赋值的时候嵌入线上公交数据
                    
                    
                }
                self.homeTableView.reloadData()
                
        })
    }
    func showBusOnlineInfo(notification:NSNotification)
    {
        /*
         ["runPathID":currectRunPathIdForBusInfo,"currentDirection":cell.changeDirectionBtn.isSelected ? 1 : 0]
        */
        let userInfo = notification.userInfo
        runPathID = userInfo?["runPathID"] as! String
        currentIndex = userInfo?["currentDirection"] as! Int
        busInfos = userInfo?["BusInfos"] as? Array
        self.getBusLineInfo()
    }
    func getBusLineInfo() // 获取路线信息，以及线上公交信息
    {
        busInfo = busInfos?[currentIndex]
        busOnlineRequestTimer = Timer(fireAt:Date( ), interval: 5, target: self, selector: #selector(busOnlineRequest), userInfo: nil, repeats: true)
        RunLoop.current.add(busOnlineRequestTimer!, forMode:.commonModes)
        BusAllStationEntity.startRequestWith(runPathID)
        { (dataModel) in
            
            //当前公交停靠站点
            
            dataModel?.flag = self.flags[self.currentIndex]//当前的flag
            
            self.busAllstation = dataModel!
            
            BusOnlineEntity.startRequestWith(self.runPathID, flag:self.flags[self.currentIndex], completionHandler:
                { (dataModel) in
                    print(self.busAllstation.currentLines.count)
                    if (dataModel?.lists?.count != 0)
                    {
                        
                        self.busAllstation.currentLines =  self.busAllstation.currentLinesFunc()
                        
                        if self.busAllstation.currentLines.count == 0
                        {
                            
                            self.homeTableView.tableHeaderView = nil
                            
                        }else // 生成表头
                        {
                            
                            let views = Bundle.main.loadNibNamed("homeTableHeaderView", owner: self, options: nil)
                            self.homeTableView.tableHeaderView = views?.first as! UIView?
                            self.startTimeLab.text = "早班"+(self.busInfo?.startTime)!
                            self.busTimeInterval.text = (self.busInfo?.busInterval)! + "分钟一班"
                            self.endTimeLab.text = "晚班"+(self.busInfo?.endTime)!
                            
                        }
                        self.busOnlineLists = (dataModel?.lists!)!//赋值的时候嵌入线上公交数据
                        
                        
                    }
                    self.homeTableView.reloadData()
                    
                    let delayQueue = DispatchQueue(label: "com.appcoda.queue", qos: .userInitiated, attributes: .concurrent)
                    let addtionalTime : DispatchTimeInterval = .seconds(5)
                    delayQueue.asyncAfter(deadline:.now() + addtionalTime)
                    {
                        self.busOnlineRequestTimer?.fire()
                    }
                    
            })
            
        }

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowLayer.backgroundColor = UIColor.ColorHex(hex: "f0f0f0").cgColor
        shadowLayer.shadowColor = UIColor.ColorHex(hex: "f0f0f0").cgColor
        shadowLayer.shadowOffset = CGSize(width:0, height:0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 4
        shadowLayer.masksToBounds = false
        shadowLayer.frame = self.homeTableView.frame
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func goToSearchVC(_ sender: Any)
    {
        //坐标系和正常的坐标系不一样,所以是这样渲染的
        
        //开始图形路径
//        let fromPath = UIBezierPath(arcCenter:CGPoint(x:170,y:667) , radius: 50, startAngle:CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise:true)
//        
//        circleLayer.path = fromPath.cgPath
//        //shapeLayer.strokeColor = UIColor.red.cgColor
//        circleLayer.fillColor = UIColor(colorLiteralRed: 254/255, green: 228/255, blue: 227/255, alpha: 1).cgColor
//        self.view.layer.addSublayer(circleLayer)
//        
//        //结束的图形路径
//        let toPath = UIBezierPath(arcCenter:CGPoint(x:170,y:300), radius: 1000, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
//        let fillAnimation = CABasicAnimation(keyPath: "path")
//        fillAnimation.fillMode = kCAFillModeForwards
//        fillAnimation.isRemovedOnCompletion = false
//        //fillAnimation.fromValue = fromPath
//        fillAnimation.toValue = toPath.cgPath
//        fillAnimation.duration = 1
//        fillAnimation.delegate = self
//        fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//        //fillAnimation.setValue(shapeLayer, forKey:"circle")
//        circleLayer.add(fillAnimation, forKey: "path")
//        
//        //颜色渐变动画
//        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
//        colorAnimation.fillMode = kCAFillModeForwards
//        colorAnimation.toValue = UIColor(colorLiteralRed: 167/255, green: 177/255, blue: 246/255, alpha: 1).cgColor
//       // colorAnimation.toValue = UIColor.white.cgColor
//        colorAnimation.isRemovedOnCompletion = false
//        colorAnimation.duration = 1
//        colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        circleLayer.add(colorAnimation, forKey: "color")
        
        let viewController = ViewController()
        
        self.animator = ZFModalTransitionAnimator(modalViewController: viewController)
        self.animator?.isDragable = true
        self.animator?.direction = .bottom
        self.animator?.setContentScrollView(viewController.resultTableView)
        
        viewController.transitioningDelegate = self.animator
        viewController.modalPresentationStyle = .custom
        
        self.present(viewController, animated: true, completion: nil)
       
    }
    @IBOutlet weak var collectBtn: UIButton!

    @IBAction func collectBusLineInfo(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        
        
    }
    
    //MARK: table datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (busAllstation.currentLines.count != 0)
        {
            collectBtn.isHidden = false
            changeDirectionBtn.isHidden = false
            return (busAllstation.currentLines.count)
        }else
        {
            collectBtn.isHidden = true
            changeDirectionBtn.isHidden = true
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: busStationV2CellID) as! BusStationV2TableViewCell
        
        
        cell.stationInfo = (busAllstation.currentLines[indexPath.row] ).stationInfo
     
        
        cell.cellIndexPath = indexPath
        cell.isTopOrBottomCell = false
        cell.clearsContextBeforeDrawing = true
        
        if indexPath.row == 0 || (indexPath.row == (busAllstation.currentLines.count-1))//判断是否是第一个或者最后一个 cell
        {
            cell.isTopOrBottomCell = true
        }
        
        cell.busWillCome = !((busAllstation.currentLines[indexPath.row]).isStation)
        cell.setNeedsDisplay()
        
        return cell
    }
}
