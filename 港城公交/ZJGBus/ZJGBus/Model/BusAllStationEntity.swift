//
//  BusAllStationEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/11.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import Alamofire
class BusAllStationEntity: BaseEntity,DictModelProtocol
{
    var runPathName = ""
    var runPathId = ""
    var roundRunPath = ""
    var xiaxing : NSArray?
    var shangxing : NSArray?
    var flag = ""
    var currentLines :[UniDataSoure]
    {
        get
        {
            
            if flag == "1"
            {
                if shangxing?.count != nil
                {
                    var uniDataSources = [UniDataSoure]()
                    
                    for busInfo in shangxing!
                    {
                        let uniDataSource = UniDataSoure()
                        uniDataSource.isStation = true
                        uniDataSource.stationInfo = busInfo as? StationInfo
                        uniDataSources.append(uniDataSource)
                    }
                    return uniDataSources
                }
            }else
            {
                if xiaxing?.count != nil
                {
                    var uniDataSources = [UniDataSoure]()
                    
                    for busInfo in xiaxing!
                    {
                        let uniDataSource = UniDataSoure()
                        uniDataSource.isStation = true
                        uniDataSource.stationInfo = busInfo as? StationInfo
                        uniDataSources.append(uniDataSource)
                    }
                    return uniDataSources
                }
            }
            return [UniDataSoure]()
        }
        set
        {
            
        }
    }
    
    class func customClassMapping() -> [String : String]?
    {
        return ["xiaxing":"StationInfo","shangxing":"StationInfo"]
    }
    class func startRequestWith(RunPathID:String ,completionHandler:(dataModel:BusAllStationEntity?) -> Void)
    {
        Alamofire.request(.POST, BASE_URL+"bus/searchSSR", parameters:["rpId":RunPathID]).responseJSON
        { (request, response, result) in
            
            if let value = result.value
            {
                if ((value as! NSDictionary)["result"] != nil)
                {
                    print("\(value)")
                    let busAllStationEntity = self.objectWithKeyValues((value as! NSDictionary)["result"]as! NSDictionary) as! BusAllStationEntity
                    completionHandler(dataModel:busAllStationEntity)
                }else
                {
                    completionHandler(dataModel:nil)
                }
            }
            
        }
    }
}
class StationInfo: BaseEntity
{
    var sn = ""
    var flag = ""
    var busStationName = ""
    var busStationId = ""
}
class UniDataSoure: BaseEntity
{
    var isStation = true
    var stationInfo:StationInfo?
    var busOnlineInfo:BusOnlineInfo?
}


