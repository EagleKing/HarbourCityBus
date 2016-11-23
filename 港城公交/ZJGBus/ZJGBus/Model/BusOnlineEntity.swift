//
//  BusOnlineEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/12.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
class BusOnlineEntity: BaseEntity,Mappable
{
    var lists:[BusOnlineInfo]?
    func mapping(map: Map) {
            lists <- map["lists"]
    }
    override init()
    {
        super.init()
    }
    required init?(map: Map) {}
    class func startRequestWith(_ runPathId:String?,flag:String?,completionHandler:@escaping (_ dataModel:BusOnlineEntity?)->Void)->Void
    {
        Alamofire.request(BASE_URL+"bus/gpsForRPF", method: .post, parameters: ["rpId":runPathId!,"flag":flag!], encoding: URLEncoding.default).responseJSON { (DataResponse) in
            if (DataResponse.result.value != nil)
            {
                
                if let JSONData =  (DataResponse.result.value as? [String : Any])?["result"] as? [String : Any]
                {
                    let busOnlineEntity = Mapper<BusOnlineEntity>().map(JSON: JSONData)
                    completionHandler(busOnlineEntity)
                }
                
            }
        }
    }
}
class BusOnlineInfo: BaseEntity,Mappable
{
    var simno = ""
    var voiceSn = ""
    var numberOfPlate = ""
    var shangxiaxing = ""
    var outstate = ""
    var gPSTime = ""
    var busStationName = ""
    var busStationId = ""
    func mapping(map: Map) {
        simno <- map["simno"]
        voiceSn <- map["simno"]
        numberOfPlate <- map["simno"]
        shangxiaxing <- map["simno"]
        outstate <- map["simno"]
        gPSTime <- map["simno"]
        busStationName <- map["simno"]
        busStationId <- map["simno"]
    }
    override init()
    {
        super.init()
    }
    required init?(map: Map) {}
}
