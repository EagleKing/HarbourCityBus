//
//  BusOnlineEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/12.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import Alamofire
class BusOnlineEntity: BaseEntity,DictModelProtocol
{
    var lists:NSArray?
    static func customClassMapping() -> [String : String]?
    {
        return ["lists":"BusOnlineInfo"]
    }
    class func startRequestWith(_ runPathId:String?,flag:String?,completionHandler:(_ dataModel:BusOnlineEntity?)->Void)->Void
    {
        
        Alamofire.request(.POST, BASE_URL+"bus/gpsForRPF", parameters: ["rpId":runPathId!,"flag":flag!]).responseJSON
        {(request, response, result) in
                if (result.value != nil)
                {
                    if let value = (result.value as! NSDictionary)["result"]
                    {
                        let busOlineEntity = BusOnlineEntity.objectWithKeyValues((value as!NSDictionary)) as!BusOnlineEntity
                        completionHandler(dataModel: busOlineEntity)
                    }else
                    {
                        completionHandler(dataModel: nil)
                    }
                }
        }
    }
}
class BusOnlineInfo: BaseEntity
{
    var simno = ""
    var voiceSn = ""
    var numberOfPlate = ""
    var shangxiaxing = ""
    var outstate = ""
    var gPSTime = ""
    var busStationName = ""
    var busStationId = ""
}
