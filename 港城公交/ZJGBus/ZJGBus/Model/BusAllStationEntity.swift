//
//  BusAllStationEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/11.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class BusAllStationEntity: BaseEntity,Mappable
{
    var runPathName = ""
    var runPathId = ""
    var roundRunPath = ""
    var flag = ""
    var xiaxing =  [StationInfo] ()
    var shangxing =  [StationInfo] ()
    var currentLines = [UniDataSoure]()
    required init?(map: Map) {}
    override init()
    {
        super.init()
    }
    func mapping(map: Map)
    {
        runPathName <- map["runPathName"]
        runPathId <- map["runPathId"]
        roundRunPath <- map["roundRunPath"]
        flag <- map["flag"]
        xiaxing <- map["xiaxing"]
        shangxing <- map["shangxing"]
        currentLines <- map["currentLines"]
    }
    func currentLinesFunc ()->[UniDataSoure]
    {
            if flag == "1"
            {
                if shangxing.count != 0
                {
                    var uniDataSources = [UniDataSoure]()
                    for busnfo in shangxing
                    {
                        let uniDataSource = UniDataSoure()
                        uniDataSource.isStation = true
                        uniDataSource.stationInfo = busnfo
                        uniDataSources.append(uniDataSource)
                    }
                    return uniDataSources
                }
            }else
            {
                if xiaxing.count != 0
                {
                    var uniDataSources = [UniDataSoure]()
                    for busInfo in xiaxing
                    {
                        let uniDataSource = UniDataSoure()
                        uniDataSource.isStation = true
                        uniDataSource.stationInfo = busInfo
                        uniDataSources.append(uniDataSource)
                    }
                    return uniDataSources
                }
            }
            return [UniDataSoure]()
    }
    class func startRequestWith(_ RunPathID:String ,completionHandler:@escaping (_ dataModel:BusAllStationEntity?) -> Void)
    {
        
        Alamofire.request(BASE_URL+"bus/searchSSR", method: .post, parameters: ["rpId":RunPathID], encoding: URLEncoding.default).responseJSON { (DataResponse) in
          
            if let JSONData =  (DataResponse.result.value as? [String : Any])?["result"] as? [String : Any]
            {
                let busAllStationEntity = Mapper<BusAllStationEntity>().map(JSON: JSONData)
                completionHandler(busAllStationEntity)
            }
            
        }
    }
}
class StationInfo: BaseEntity,Mappable
{
    var sn = ""
    var flag = ""
    var busStationName = ""
    var busStationId = ""
    override init()
    {
        super.init()
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        sn <- map["sn"]
        flag <- map["flag"]
        busStationName <- map["busStationName"]
        busStationId <- map["busStationId"]
    }
}
class UniDataSoure: BaseEntity
{
    var isStation = true
    var stationInfo:StationInfo?
    var busOnlineInfo:BusOnlineInfo?
}


