//
//  BusInfoWithRunPathID.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/9.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import Alamofire
class BusInfoWithRunPathID: BaseEntity
{
    var endTime1 = ""
    var startTime = ""
    var startStation = ""
    var runFlag = ""
    var runPathName = ""
    var busInterval = ""
    var endStation = ""
    var endTime = ""
    var startTime1 = ""
    class  func startRequest(_ runPathId:String,flag:String ,completionHander:(_ dataModel:BusInfoWithRunPathID)->Void)
    {
        Alamofire.request(.POST, BASE_URL+"common/busQuery", parameters: ["runPathId":runPathId,"flag":flag]).responseJSON
            { (request, response, result) in
                if let value = result.value
                {
                    let dataModel = BusInfoWithRunPathID.objectWithKeyValues((((value as! NSDictionary)["result"])as! NSDictionary))as! BusInfoWithRunPathID
            
                    completionHander(dataModel: dataModel)
                    
                }
            }
    }
}
