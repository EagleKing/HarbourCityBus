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
    
    
    let busStationCellID = "busStationCellID"
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
        stationInfosTableView.registerNib(UINib.init(nibName: "BusStationTableViewCell", bundle: nil), forCellReuseIdentifier:busStationCellID)
        self.navigationItem.title = "211路"
        self.navigationItem.prompt = "路线详情"
        stationInfosTableView.tableFooterView = UIView()
        //站点信息
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        BusAllStationEntity.startRequestWith(runPathID)
        { (dataModel) in
            
            self.busAllstation = dataModel!
            
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if (busAllstation.xiaxing?.count != nil)
       {
            return (busAllstation.xiaxing?.count)!
       }else {return 0}
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(busStationCellID)
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
}
