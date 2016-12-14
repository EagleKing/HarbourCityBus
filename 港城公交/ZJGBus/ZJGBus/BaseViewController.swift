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
        self.edgesForExtendedLayout = UIRectEdge()
        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.navigationBar.tintColor = UIColor(hex: UniversalColorHexString)
        
        //配置左侧barbuttonitem
        let backBtn = UIButton.init(type: .custom)
        backBtn.addTarget(self, action:#selector(goBack), for:.touchUpInside)
        backBtn.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
        backBtn.setImage(UIImage.init(named: "back"), for: UIControlState())
        
        let backBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBarButtonItem.title = ""
        
        let itemSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        itemSpacer.width = -8
        
        self.navigationItem.leftBarButtonItems = [itemSpacer,backBarButtonItem]
        
        //添加右滑返回
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.hidesBarsOnSwipe = true
        
    }
    func goBack(){_ = self.navigationController?.popViewController(animated: true)}

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
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
