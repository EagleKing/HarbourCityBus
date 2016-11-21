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
    class func startRequestWith(_ runPathId:String?,flag:String?,completionHandler:@escaping (_ dataModel:BusOnlineEntity?)->Void)->Void
    {
        Alamofire.request(BASE_URL+"bus/gpsForRPF", method: .post, parameters: ["rpId":runPathId!,"flag":flag!], encoding: JSONEncoding.default).responseJSON { (DataResponse) in
            if (DataResponse.result.value != nil)
            {
                if let value = (DataResponse.result.value as! NSDictionary)["result"]
                {
                    let busOlineEntity = BusOnlineEntity.objectWithKeyValues((value as!NSDictionary)) as!BusOnlineEntity
                    completionHandler(busOlineEntity)
                }else
                {
                    completionHandler(nil)
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
