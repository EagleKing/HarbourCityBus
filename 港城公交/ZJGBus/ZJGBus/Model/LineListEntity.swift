//
//  LineListEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import Foundation
import Alamofire


class LineListEntity: BaseEntity
{
    var endId:String = ""
    var endName:String = ""
    var runPathId:String = ""
    var runPathName:String = ""
    var srartId:String = ""
    var startName:String = ""
}
class LineList:BaseEntity,DictModelProtocol
{
    var lines : NSArray?
    class func customClassMapping() -> [String : String]?
    {
        return ["lines":"LineListEntity"]
    }
    class func startRequestWith(_ name:String?, completionHandler:@escaping (_ dataModel:LineList?) -> Void)
    {
        
        if name != nil
        {
            Alamofire.request(BaseEntity.BASE_URL+"bus/allStationOfRPName", method: .post, parameters: ["name":name!], encoding: JSONEncoding.default).responseJSON(completionHandler: { (DataResponse) in
                if let value = DataResponse.result.value
                {
                    print(value)
                    
                    if ((value as! NSDictionary)["result"] != nil)// 这里也是坑
                    {
                        let lineList = self.objectWithKeyValues((((value as! NSDictionary)["result"]) as! NSDictionary)) as! LineList
                        completionHandler(lineList)
                        //尼玛，字典转模型的坑终于踩完了
                    }else
                    {
                        completionHandler(nil)
                    }
                    
                    
                }
            })
        }
    }
}
