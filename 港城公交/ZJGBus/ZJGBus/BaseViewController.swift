//
//  BaseViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/9.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = true
        
        
        //配置左侧barbuttonitem
        let backBtn = UIButton.init(type: .Custom)
        backBtn.addTarget(self, action:#selector(goBack), forControlEvents:.TouchUpInside)
        backBtn.frame = CGRectMake(0,0,25,25)
        backBtn.setImage(UIImage.init(named: "back"), forState: .Normal)
        
        let backBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBarButtonItem.title = ""
        
        let itemSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        itemSpacer.width = -8
        
        self.navigationItem.leftBarButtonItems = [itemSpacer,backBarButtonItem]
        
        //添加右滑返回
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.hidesBarsOnSwipe = true
        
    }
    func goBack(){self.navigationController?.popViewControllerAnimated(true)}

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if self.navigationController?.viewControllers.count == 1
        {
            return false
        }else
        {
            return true
        }
    }
}
