//
//  BaseEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import Foundation


class BaseEntity:Reflect
{
    internal static let FLAG_LINE_GO = "1"
    internal static let FLAG_LINE_BACK = "2"
    internal static let FlAG_BUS_GO = "1"
    internal static let FLAG_BUS_BACK = "3"
    internal static let BASE_URL = "http://61.177.44.242:8080/BusSysWebService/"
    internal static var isStartRequest = true
}
extension NSObject
{
    class func objectWithKeyValues(keyValues:NSDictionary) -> AnyObject{
        let model = self.init()
        //存放属性的个数
        var outCount:UInt32 = 0
        //获取所有的属性
        let properties = class_copyPropertyList(self.classForCoder(), &outCount)
        //遍历属性
        for i in 0 ..< Int(outCount) {
            //获取第i个属性
            let property = properties[i]
            //得到属性的名字
            let key = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            if let value = keyValues[key]{
                //为model类赋值
                model.setValue(value, forKey: key as String)
            }
        }
        return model
    }
}