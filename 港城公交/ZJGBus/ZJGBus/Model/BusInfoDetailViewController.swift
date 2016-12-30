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
    var runPathID  = ""
    let flags = ["1","3"]
    var currentIndex = 0

    var dataSource : NSDictionary = [:]
    
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
                        busAllstation.currentLines.insert(uniDataSource, at:i)
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
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        stationInfosTableView.register(UINib.init(nibName:"BusStationTableViewCell", bundle:nil), forCellReuseIdentifier:busStationCellID)
        stationInfosTableView.register(UINib.init(nibName:"onlineBusTableViewCell", bundle:nil), forCellReuseIdentifier:onlineBusCellID)
        stationInfosTableView.register(UINib(nibName:"BusStationV2TableViewCell",bundle:nil), forCellReuseIdentifier: busStationV2CellID)
        self.navigationItem.title = "211路"
        self.navigationItem.prompt = "路线详情"
        stationInfosTableView.tableFooterView = UIView()
        //站点信息
        
        BusAllStationEntity.startRequestWith(runPathID)
        { (dataModel) in
            
            //当前公交停靠站点
            
            dataModel?.flag = self.flags[self.currentIndex]//当前的flag
            
            self.busAllstation = dataModel!
            BusOnlineEntity.startRequestWith(self.runPathID, flag:self.flags[self.currentIndex], completionHandler:
            { (dataModel) in
                print(self.busAllstation.currentLines.count)
               if (dataModel?.lists != nil)
               {
                self.busOnlineLists = (dataModel?.lists!)!
               }
                let uniDataSource = UniDataSoure()
                //uniDataSource.busOnlineInfo = UniDataSoure()
                
                uniDataSource.isStation = false
                uniDataSource.busOnlineInfo = dataModel?.lists?[0]
                self.busAllstation.currentLines =  self.busAllstation.currentLinesFunc()
                
                
                //////这里写插入线上公交的代码
                
                //////
                self.busAllstation.currentLines.insert(uniDataSource, at: 5)
                self.stationInfosTableView.reloadData()
                
                print(self.busAllstation.currentLines.count)
                
                
            })
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if (busAllstation.currentLines.count != 0)
       {
            return (busAllstation.currentLines.count)
       }else {return 0}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: busStationV2CellID) as! BusStationV2TableViewCell
            if (busAllstation.currentLines[indexPath.row]).isStation
            {
                 cell.stationInfo = (busAllstation.currentLines[indexPath.row] ).stationInfo!
            }else
            {
                
            }
        
            cell.cellIndexPath = indexPath
            cell.isTopOrBottomCell = false
            cell.clearsContextBeforeDrawing = true
            if indexPath.row == 0 || (indexPath.row == (busAllstation.currentLines.count-1))
            {
                cell.isTopOrBottomCell = true
            }
            cell.busWillCome = !((busAllstation.currentLines[indexPath.row]).isStation)
            cell.setNeedsDisplay()
        
            return cell
     
    }
    func calcutelate(_ busGPSTime:String) -> String
    {
        return "暂时没算"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
   
}
