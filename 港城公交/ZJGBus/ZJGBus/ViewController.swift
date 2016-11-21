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
    case busInfoType
}
class ViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource
{
    let searchResultCellID = "searchResultCell"
    let customSearchResultCellID = "customSearchResultCellID"
    let BusInfoCellID = "BusInfoCell"
    var currectRunPathIdForBusInfo = ""
    
    
    
    var tableViewType = searchResultType.searchResultType
    var searchBar = UISearchBar()
    var resultTableView = UITableView(frame: CGRect.zero, style:.plain)
    
    var busInfos = [BusInfoWithRunPathID]()
        {
            didSet
            {
                if busInfos.count == 2
                {
                    tableViewType = .busInfoType
                    resultTableView.separatorStyle = .none
                    resultTableView.backgroundColor = UIColor.groupTableViewBackground
                    self.resultTableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
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
        let image = self.navigationController?.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.tabBarItem.selectedImage = image;
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    //MARK:配置UI
    func congureUI()
    {
        //初始化搜索
        searchBar.barStyle          = .default
        searchBar.delegate          = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.backgroundImage   = UIImage()
        searchBar.placeholder       = "请输入你要查询的线路"
        //添加阴影
        searchBar.layer.shadowOffset = CGSize(width: 3, height: 3)
        searchBar.layer.shadowColor = UIColor.lightGray.cgColor
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowRadius = 3
        
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints
        { (make) in
                make.top.equalTo(self.view.snp.top).offset(20)
                make.right.equalTo(self.view.snp.right).offset(-10)
                make.left.equalTo(self.view.snp.left).offset(10)
        }
        
        //初始化搜索结果
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.separatorInset = UIEdgeInsets.zero
        resultTableView.tableFooterView = UIView()
        resultTableView.keyboardDismissMode = .onDrag
        resultTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: searchResultCellID)
        resultTableView.register(UINib.init(nibName:"SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: customSearchResultCellID)
        resultTableView.register(UINib.init(nibName:"BusLineInfoTableViewCell", bundle: nil), forCellReuseIdentifier: BusInfoCellID)
        self.view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints
        { (make) in
                make.top.equalTo(searchBar.snp.bottom)
                make.right.equalTo(self.view.snp.right)
                make.left.equalTo(self.view.snp.left)
                make.bottom.equalTo(self.view.snp.bottom)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if resultTableView.separatorStyle == .none
        {
            resultTableView.separatorStyle = .singleLineEtched
        }
        MBProgressHUD.showAdded(to: self.view, animated:true)
        
        LineList.startRequestWith(searchBar.text, completionHandler:
        {lineList in
                self.tableViewType = .searchResultType
                if (lineList != nil)
                {
                   self.lineList = lineList! 
                }
            
                MBProgressHUD.hide(for: self.view, animated:true)
            
        })
    }
    //MARK:tableview delegate/datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch tableViewType
        {
        case .busInfoType: return 150
        case .searchResultType: return 100
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableViewType == .searchResultType
        {
            let cell:SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: customSearchResultCellID, for: indexPath) as! SearchResultTableViewCell
            
            let lineEnity:LineListEntity = lineList.lines![(indexPath as NSIndexPath).row] as! LineListEntity
            cell.numberOfBus.text = lineEnity.runPathName
            cell.startAndEndTimeLab.text = lineEnity.startName
            cell.intervalTimeLab.text = lineEnity.endName
            return cell
        }else
        {
            let cell:BusLineInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: BusInfoCellID, for: indexPath) as! BusLineInfoTableViewCell
            cell.BusInfo  = busInfos[(indexPath as NSIndexPath).row]
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.separatorInset = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        tableView.deselectRow(at: indexPath, animated: true)
        if tableViewType == .searchResultType
        {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let busInfosQueue = DispatchQueue(label: "com.rockstar.businfosQueue",attributes: [])
            let globalBackgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
            busInfosQueue.setTarget(queue: globalBackgroundQueue)//改变优先级


            let lineEnity:LineListEntity = lineList.lines![(indexPath as NSIndexPath).row] as! LineListEntity
            currectRunPathIdForBusInfo = lineEnity.runPathId//路线id
            let flags = ["1","2"]
            
            busInfos.removeAll()
            BusInfoWithRunPathID.startRequest(lineEnity.runPathId, flag:flags[0])
            { (dataModel) in
                busInfosQueue.async(execute: {
                    
                   DispatchQueue.main.async(execute: { //返回主队列更新UI
                    //上下行1 dataModel数据model
                    self.busInfos.append(dataModel)
                    
                    print("1111")
                    
                   })
                   
                })
            }
            BusInfoWithRunPathID.startRequest(lineEnity.runPathId, flag:flags[1])
            { (dataModel) in
                busInfosQueue.async(execute: {
                    
                    DispatchQueue.main.async(execute: {//返回主队列更新UI
                        //上下行3 dataModel数据model
                        self.busInfos.append(dataModel)
                        
                        print("22222")
                    })
                    
                })
            }
            
        }else
        {
            
            let busInfoDetailVC = BusInfoDetailViewController()
            busInfoDetailVC.runPathID = currectRunPathIdForBusInfo
            busInfoDetailVC.currentIndex = (indexPath as NSIndexPath).row
            busInfoDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(busInfoDetailVC, animated: true)
            
        }
    }
}

