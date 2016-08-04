//
//  LineListEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LineListEntity: BaseEntity
{
    private var endTime1:String = ""
    private var startTime:String = ""
    private var startStation:String = ""
    private var runFlag:String = ""
    private var runPathName:String = ""
    private var busInterval:String = ""
    private var endStation:String = ""
    private var runPathIds:String = ""
    private var endTime:String = ""
    private var startTime1:String = ""
}
class LineList:BaseEntity
{
    private var Lines = [LineListEntity]()
    static func startRequestWith(name:String?)
    {
        
        if name != nil
        {
            Alamofire.request(.POST, BaseEntity.BASE_URL+"bus/allStationOfRPName", parameters: ["name":name!]).responseJSON(options:NSJSONReadingOptions.AllowFragments, completionHandler:
                { (request, response, result) in
                    if let value = result.value
                    {
                        
                        let resultDic = value["result"]!
                      
                        let lineList = LineList.parse(dict: resultDic as! NSDictionary)
                        
                    
                        print(lineList.Lines)
                    }
                })
        }
    }
}
