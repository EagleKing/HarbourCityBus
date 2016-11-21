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
    class  func startRequest(_ runPathId:String,flag:String ,completionHander:@escaping (_ dataModel:BusInfoWithRunPathID)->Void)
    {
        Alamofire.request(BASE_URL+"common/busQuery", method: .post, parameters:  ["runPathId":runPathId,"flag":flag], encoding: JSONEncoding.default).responseJSON { (DataResponse) in
            if let value = DataResponse.result.value
            {
                let dataModel = BusInfoWithRunPathID.objectWithKeyValues((((value as! NSDictionary)["result"])as! NSDictionary))as! BusInfoWithRunPathID
                
                completionHander(dataModel)
                
            }
        }
    }
}
