//
//  ViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

enum searchResultType
{
    case searchResultType
    case BusInfoType
}
class ViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource
{
    let searchResultCellID = "searchResultCell"
    let customSearchResultCellID = "customSearchResultCellID"
    let BusInfoCellID = "BusInfoCell"
    var currectRunPathIdForBusInfo = ""
    
    
    
    var tableViewType = searchResultType.searchResultType
    var searchBar = UISearchBar()
    var resultTableView = UITableView(frame: CGRectZero, style:.Plain)
    
    var busInfos = [BusInfoWithRunPathID]()
        {
            didSet
            {
                if busInfos.count == 2
                {
                    tableViewType = .BusInfoType
                    resultTableView.separatorStyle = .None
                    resultTableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    self.resultTableView.reloadData()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }
        }
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
        //修改选中图片
        let image = self.navigationController?.tabBarItem.selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.tabBarItem.selectedImage = image;
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    //MARK:配置UI
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
        resultTableView.separatorInset = UIEdgeInsetsZero
        resultTableView.tableFooterView = UIView()
        resultTableView.keyboardDismissMode = .OnDrag
        resultTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: searchResultCellID)
        resultTableView.registerNib(UINib.init(nibName:"SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: customSearchResultCellID)
        resultTableView.registerNib(UINib.init(nibName:"BusLineInfoTableViewCell", bundle: nil), forCellReuseIdentifier: BusInfoCellID)
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
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if resultTableView.separatorStyle == .None
        {
            resultTableView.separatorStyle = .SingleLineEtched
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated:true)
        
        LineList.startRequestWith(searchBar.text, completionHandler:
        {lineList in
                self.tableViewType = .searchResultType
                if (lineList != nil)
                {
                   self.lineList = lineList! 
                }
            
                MBProgressHUD.hideHUDForView(self.view, animated:true)
            
        })
    }
    //MARK:tableview delegate/datasource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch tableViewType
        {
        case .BusInfoType: return 150
        case .searchResultType: return 100
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if tableViewType == .searchResultType
        {
            if ((lineList.lines?.count) != nil)
            {
                return (lineList.lines?.count)!
            }else {return 0}
        }else
        {
            return busInfos.count
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableViewType == .searchResultType
        {
            let cell:SearchResultTableViewCell = tableView.dequeueReusableCellWithIdentifier(customSearchResultCellID, forIndexPath: indexPath) as! SearchResultTableViewCell
            
            let lineEnity:LineListEntity = lineList.lines![indexPath.row] as! LineListEntity
            cell.numberOfBus.text = lineEnity.runPathName
            cell.startAndEndTimeLab.text = lineEnity.startName
            cell.intervalTimeLab.text = lineEnity.endName
            return cell
        }else
        {
            let cell:BusLineInfoTableViewCell = tableView.dequeueReusableCellWithIdentifier(BusInfoCellID, forIndexPath: indexPath) as! BusLineInfoTableViewCell
            cell.BusInfo  = busInfos[indexPath.row]
            return cell
        }
        
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableViewType == .searchResultType
        {
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let busInfosQueue = dispatch_queue_create("com.rockstar.businfosQueue",DISPATCH_QUEUE_SERIAL)
            let globalBackgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
            dispatch_set_target_queue(busInfosQueue, globalBackgroundQueue)//改变优先级

            let lineEnity:LineListEntity = lineList.lines![indexPath.row] as! LineListEntity
            currectRunPathIdForBusInfo = lineEnity.runPathId//路线id
            let flags = ["1","2"]
            
            busInfos.removeAll()
            BusInfoWithRunPathID.startRequest(lineEnity.runPathId, flag:flags[0])
            { (dataModel) in
                dispatch_async(busInfosQueue,
                {
                    
                   dispatch_async(dispatch_get_main_queue(), { //返回主队列更新UI
                    //上下行1 dataModel数据model
                    self.busInfos.append(dataModel)
                    
                    print("1111")
                    
                   })
                   
                })
            }
            BusInfoWithRunPathID.startRequest(lineEnity.runPathId, flag:flags[1])
            { (dataModel) in
                dispatch_async(busInfosQueue,
                {
                    
                    dispatch_async(dispatch_get_main_queue(), {//返回主队列更新UI
                        //上下行3 dataModel数据model
                        self.busInfos.append(dataModel)
                        
                        print("22222")
                    })
                    
                })
            }
            
        }else
        {
            
            var busInfoDetailVC = BusInfoDetailViewController()
            busInfoDetailVC.runPathID = currectRunPathIdForBusInfo
            busInfoDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(busInfoDetailVC, animated: true)
            
        }
    }
}

