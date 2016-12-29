//
//  EdgeInsetsLabel.swift
//  ZJGBus
//
//  Created by EagleMan on 2016/12/27.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class EdgeInsetsLabel: UILabel
{
    override var alignmentRectInsets: UIEdgeInsets
    {
                get
                {
                    return UIEdgeInsetsMake(8, 8, 8, 8)
                }
        }
}

