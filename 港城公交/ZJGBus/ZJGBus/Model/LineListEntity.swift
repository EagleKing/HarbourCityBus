//
//  LineListEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class LineListEntity: BaseEntity,Mappable
{
    var endId:String       = ""
    var endName:String     = ""
    var runPathId:String   = ""
    var runPathName:String = ""
    var srartId:String     = ""
    var startName:String   = ""
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        endId <- map["endId"]
        endName <- map["endName"]
        runPathId <- map["runPathId"]
        runPathName <- map["runPathName"]
        srartId <- map["srartId"]
        startName <- map["startName"]
    }
}
class LineList:BaseEntity,Mappable
{
    var lines : [AnyObject]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        lines <- map["lines"]
    }
    class func startRequestWith(_ name:String?, completionHandler:@escaping (_ dataModel:LineList?) -> Void)
    {
        if name != nil
        {
            let params = ["name":name!]
            
            Alamofire.request(BaseEntity.BASE_URL+"bus/allStationOfRPName", method: .get, parameters: params, encoding: URLEncoding.default)
                         .responseJSON(completionHandler: { (DataResponse) in
                            
                            
                            let dataModel = Mapper<LineList>().map(JSON: DataResponse.result.value as! [String : Any]);
                            completionHandler(dataModel);
                            
                            
                            
            })
        }
    }
}
