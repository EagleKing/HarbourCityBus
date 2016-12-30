//
//  BusInfoWithRunPathID.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/9.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class BusInfoWithRunPathID: BaseEntity,Mappable
{
    var endTime1 :String = ""
    var startTime :String = ""
    var startStation :String = ""
    var runFlag :String = ""
    var runPathName :String = ""
    var busInterval :String = ""
    var endStation :String = ""
    var endTime :String = ""
    var startTime1 :String = ""
    
    
    //额外添加
    var runPathID: String?
    required init?(map: Map) {
    }
    override init()
    {
        super.init()
    }
    func mapping(map: Map) {
            endTime1 <- map["endTime1"]
            startTime <- map["startTime"]
            startStation <- map["startStation"]
            runFlag <- map["runFlag"]
            runPathName <- map["runPathName"]
            busInterval <- map["busInterval"]
            endStation <- map["endStation"]
            endTime <- map["endTime"]
            startTime1 <- map["startTime1"]
    }
    class  func startRequest(_ runPathId:String,flag:String ,completionHander:@escaping (_ dataModel:BusInfoWithRunPathID)->Void)
    {
        Alamofire.request(BASE_URL+"common/busQuery", method: .post, parameters:  ["runPathId":runPathId,"flag":flag], encoding: URLEncoding.default).responseJSON { (DataResponse) in
               if let JSONData =  (DataResponse.result.value as? [String : Any])?["result"] as? [String : Any]
               {
                    let dataModel = Mapper<BusInfoWithRunPathID>().map(JSON: JSONData)
                    completionHander(dataModel!)
               }
        }
    }
}
