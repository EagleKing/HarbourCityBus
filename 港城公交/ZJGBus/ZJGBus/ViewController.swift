//
//  ViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource
{
    let searchResultCellID = "searchResultCell"
    var searchBar = UISearchBar()
    var resultTableView = UITableView(frame: CGRectZero, style:.Plain)
    var lineList = LineList()
    {
        didSet
        {
            resultTableView.reloadData()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.congureUI()
    }
    func congureUI()
    {
        //初始化搜索
        searchBar.barStyle          = .Default
        searchBar.delegate          = self
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.backgroundImage   = UIImage()
        searchBar.placeholder       = "请输入你要查询的线路"
        //添加阴影
        searchBar.layer.shadowOffset = CGSizeMake(3, 3)
        searchBar.layer.shadowColor = UIColor.lightGrayColor().CGColor
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowRadius = 3
        
        self.view.addSubview(searchBar)
        searchBar.snp_makeConstraints
        { (make) in
                make.top.equalTo(self.view.snp_top).offset(20)
                make.right.equalTo(self.view.snp_right).offset(-10)
                make.left.equalTo(self.view.snp_left).offset(10)
        }
        
        //初始化搜索结果
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.tableFooterView = UIView()
        resultTableView.keyboardDismissMode = .OnDrag
        resultTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: searchResultCellID)
        self.view.addSubview(resultTableView)
        resultTableView.snp_makeConstraints
        { (make) in
                make.top.equalTo(searchBar.snp_bottom)
                make.right.equalTo(self.view.snp_right)
                make.left.equalTo(self.view.snp_left)
                make.bottom.equalTo(self.view.snp_bottom)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        LineList.startRequestWith(searchText, completionHandler:
        {lineList in
            self.lineList = lineList
        })
        
    }
    
    //MARK:tableview delegate/datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if ((lineList.lines?.count) != nil)
        {
            return (lineList.lines?.count)!
        }else {return 0}
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchResultCellID, forIndexPath: indexPath)
        cell.textLabel?.text = (lineList.lines![indexPath.row] as! LineListEntity).startName
        return cell
    }
}

