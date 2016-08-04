//
//  ViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate{
    var searchBar = UISearchBar()
    var lineList = LineList()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.congureUI()
    }
    func congureUI()
    {
        //初始化搜索
        searchBar.barStyle = .Default
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        searchBar.snp_makeConstraints
            { (make) in
                make.top.equalTo(self.view.snp_top).offset(20)
                make.right.equalTo(self.view.snp_right)
                make.left.equalTo(self.view.snp_left)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        LineList.startRequestWith(searchBar.text)
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        
    }
}

