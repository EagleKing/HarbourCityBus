//
//  HE_Model2Dict.swift
//  HEExtention
//
//  Created by 贺俊孟 on 16/4/27.
//  Copyright © 2016年 贺俊孟. All rights reserved.
//  模型传字典

import Foundation

extension NSObject{
    var keyValues:[String:AnyObject]?{                   //获取一个模型对应的字典
        get{
            var result = [String: AnyObject]()           //保存结果
            var classType:AnyClass = self.classForCoder
            while("NSObject" !=  "\(classType)" ){
                var count:UInt32 = 0
                let properties = class_copyPropertyList(classType, &count)
                for i in 0..<count{
                    let property = properties[Int(i)]
                    let propertyKey = String.fromCString(property_getName(property))!         //模型中属性名称
                    let propertyType = String.fromCString(property_getAttributes(property))!  //模型中属性类型
                    
                    if "description" == propertyKey{ continue }   //描述，不是属性
                    
                    let tempValue:AnyObject!  = self.valueForKey(propertyKey)
                    if  tempValue == nil { continue }
                    
                    if let _ =  HEFoundation.getType(propertyType) {         //1,自定义的类
                        result[propertyKey] = tempValue.keyValues
                    }else if (propertyType.containsString("NSArray")){       //2, 数组, 将数组中的模型转成字典
                        result[propertyKey] = tempValue.keyValuesArray       //3， 基本数据
                    }else{
                        result[propertyKey] = tempValue
                    }
                }
                free(properties)
                classType = classType.superclass()!
            }
            if result.count == 0{
                return nil
            }else{
                return result
            }
            
        }
    }
}

extension NSArray{  //数组的拓展
    var keyValuesArray:[AnyObject]?{
        get{
            var result = [AnyObject]()
            for item in self{
                if !HEFoundation.isClassFromFoundation(item.classForCoder){ //1,自定义的类
                    let subKeyValues:[String:AnyObject]! = item.keyValues
                    if  subKeyValues == nil {continue}
                    result.append(subKeyValues)
                }else if item.classForCoder == NSArray.classForCoder(){    //2, 如果item 是数组
                    let subKeyValues:[AnyObject]! = item.keyValuesArray
                    if  subKeyValues == nil {continue}
                    result.append(subKeyValues)
                }else{                                                     //3, 基本数据类型
                    result.append(item)
                }
            }
            if result.count == 0{
                return nil
            }else{
                return result
            }
            
        }
    }
}