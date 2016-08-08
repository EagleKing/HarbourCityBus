//
//  HEFoundation.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.


import Foundation

class HEFoundation {
    
    static let set = NSSet(array: [
                                    NSURL.classForCoder(),
                                    NSDate.classForCoder(),
                                    NSValue.classForCoder(),
                                    NSData.classForCoder(),
                                    NSError.classForCoder(),
                                    NSArray.classForCoder(),
                                    NSDictionary.classForCoder(),
                                    NSString.classForCoder(),
                                    NSAttributedString.classForCoder()
                                  ])
    static let  bundlePath = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
    
    /*** 判断某个类是否是 Foundation中自带的类 */
    class func isClassFromFoundation(c:AnyClass)->Bool {
        var  result = false
        if c == NSObject.classForCoder(){
            result = true
        }else{
            set.enumerateObjectsUsingBlock({ (foundation,  stop) -> Void in
                if  c.isSubclassOfClass(foundation as! AnyClass) {
                    result = true
                    stop.initialize(true)
                }
            })
        }
        return result
    }
    
    /** 很据属性信息， 获得自定义类的 类名*/
     /**
     let propertyType = String.fromCString(property_getAttributes(property))! 获取属性类型
     到这个属性的类型是自定义的类时， 会得到下面的格式： T+@+"+..+工程的名字+数字+类名+"+,+其他,
     而我们想要的只是类名，所以要修改这个字符串
     */
    class func getType(var code:String)->String?{
        
        if !code.containsString(bundlePath){ //不是自定义类
            return nil
        }
        code = code.componentsSeparatedByString("\"")[1]
        if let range = code.rangeOfString(bundlePath){
            code = code.substringFromIndex(range.endIndex)
            var numStr = "" //类名前面的数字
            for c:Character in code.characters{
                if c <= "9" && c >= "0"{
                    numStr+=String(c)
                }
            }
            if let numRange = code.rangeOfString(numStr){
                code = code.substringFromIndex(numRange.endIndex)
            }
            return bundlePath+"."+code
        }
        return nil
    }
}
