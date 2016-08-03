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
    func startRequestWith(name:String?)
    {
        
        if name != nil
        {
            print(name)
            Alamofire.request(.POST, BaseEntity.BASE_URL+"bus/allStationOfRPName", parameters: ["name":name!]).responseJSON(completionHandler:
            { (request, reponse, result) in
               print(result.data)
               
                
            })
            
        }
    }
}
