//
//  BaseEntity.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import Foundation


class BaseEntity:NSObject
{
     static let FLAG_LINE_GO   = "1"
     static let FLAG_LINE_BACK = "2"
     static let FlAG_BUS_GO    = "1"
     static let FLAG_BUS_BACK  = "3"
     static let BASE_URL       = "http://61.177.44.242:8080/BusSysWebService/"
     static var isStartRequest = true
}
