//
//  BusInfoDetailViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/11.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class BusInfoDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var stationInfosTableView: UITableView!
    var runPathID = ""
    let flags = ["1","3"]
    var currentIndex = 0

    var dataSource = [:]
    
    var busOnlineLists = [BusOnlineInfo]()
    {
        didSet
        {
            for currentBusEntity in busOnlineLists
            {
                for i in 0 ..< busAllstation.currentLines.count
                {
                    if currentBusEntity.busStationName == (busAllstation.currentLines[i]).stationInfo!.busStationName
                    {
                        let uniDataSource = UniDataSoure()
                        uniDataSource.busOnlineInfo = currentBusEntity
                        uniDataSource.isStation = false
                        busAllstation.currentLines.insert(uniDataSource, atIndex:i)
                        
                    }
                }
            }
            stationInfosTableView.reloadData()
        }
    }
    
    let busStationCellID = "busStationCellID"
    let onlineBusCellID = "onlineBusCellID"
    var busAllstation = BusAllStationEntity()
    {
        didSet
        {
            stationInfosTableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        stationInfosTableView.registerNib(UINib.init(nibName:"BusStationTableViewCell", bundle:nil), forCellReuseIdentifier:busStationCellID)
        stationInfosTableView.registerNib(UINib.init(nibName:"onlineBusTableViewCell", bundle:nil), forCellReuseIdentifier:onlineBusCellID)
        self.navigationItem.title = "211路"
        self.navigationItem.prompt = "路线详情"
        stationInfosTableView.tableFooterView = UIView()
        //站点信息
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        BusAllStationEntity.startRequestWith(runPathID)
        { (dataModel) in
            
            //当前公交停靠站点
            
            dataModel?.flag = self.flags[self.currentIndex]//当前的flag
            
            self.busAllstation = dataModel!
            BusOnlineEntity.startRequestWith(self.runPathID, flag:self.flags[self.currentIndex], completionHandler:
            { (dataModel) in
        
               if (dataModel?.lists != nil)
               {
                self.busOnlineLists = dataModel?.lists as! [BusOnlineInfo]
               }
                
            })
            
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if (busAllstation.currentLines.count != 0)
       {
            return (busAllstation.currentLines.count)
       }else {return 0}
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if (busAllstation.currentLines[indexPath.row]).isStation
        {
            let cell = tableView.dequeueReusableCellWithIdentifier(busStationCellID) as! BusStationTableViewCell
            cell.stationLab.text = (busAllstation.currentLines[indexPath.row] ).stationInfo!.busStationName
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier(onlineBusCellID) as! onlineBusTableViewCell
            let busOnlineInfo = (busAllstation.currentLines[indexPath.row] ).busOnlineInfo
            cell.plateNoLab.text = busOnlineInfo!.numberOfPlate
            cell.timeLab.text = self.calcutelate(busOnlineInfo!.gPSTime)
            cell.currentStationLab.text = busOnlineInfo?.busStationName
            return cell
        }
    }
    func calcutelate(busGPSTime:String) -> String
    {
        return "暂时没算"
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
}
