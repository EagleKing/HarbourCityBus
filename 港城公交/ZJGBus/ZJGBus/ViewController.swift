//
//  ViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 16/8/3.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import ObjectMapper

enum searchResultType
{
    case searchResultType
    case busInfoType
}
class ViewController: BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource
{
    
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
                    self.resultTableView.reloadData()
                }
            }
        }
    var lineList:LineList = LineList()
    {
        didSet
        {
            resultTableView.reloadData()
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.congureUI()
        //修改选中图片
        let image = self.navigationController?.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.tabBarItem.selectedImage = image
        resultTableView.backgroundView = UIImageView(image:#imageLiteral(resourceName: "搜索结果") )
        resultTableView.separatorStyle = .none
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
        searchBar.layer.shadowColor = UIColor.ColorHex(hex: "f0f0f0").cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowRadius = 3
        
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints
        { (make) in
                make.top.equalTo(self.view.snp.top).offset(20)
                make.right.equalTo(self.view.snp.right)
                make.left.equalTo(self.view.snp.left)
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
        resultTableView.register(UINib.init(nibName:"BusLineInfoV2TableViewCell", bundle: nil), forCellReuseIdentifier: BusLineInfoV2CellID)
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
        resultTableView.separatorStyle = .none
        LineList.startRequestWith(searchBar.text, completionHandler:
        {lineList in
                self.tableViewType = .searchResultType
                if (lineList != nil)
                {
                   self.lineList = lineList! 
                }
        })
    }
    //MARK:tableview delegate/datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch tableViewType
        {
        case .busInfoType: return 120
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
            return 1
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
            
            let lineEnity:LineListEntity = lineList.lines![(indexPath as NSIndexPath).row] 
            cell.numberOfBus.text = lineEnity.runPathName
            cell.startAndEndTimeLab.text = lineEnity.startName
            cell.intervalTimeLab.text = lineEnity.endName
            
            return cell
        }else
        {
            let cell:BusLineInfoV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: BusLineInfoV2CellID, for: indexPath) as! BusLineInfoV2TableViewCell
            cell.busInfos  = busInfos
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
            let busInfosQueue = DispatchQueue(label: "com.rockstar.businfosQueue",attributes: [])
            _ = DispatchQueue.global(qos:.utility)//指定线程优先级
           
        //    busInfosQueue.setTarget(queue: globalBackgroundQueue)//改变优先级
            
            let lineEnity:LineListEntity = lineList.lines![(indexPath as NSIndexPath).row] 
            currectRunPathIdForBusInfo = lineEnity.runPathId//路线id
            let flags = ["1","2"]
            
            busInfos.removeAll()
            BusInfoWithRunPathID.startRequest(lineEnity.runPathId, flag:flags[0])
            { (dataModel) in
                busInfosQueue.async(execute:{
                    
                   DispatchQueue.main.async(execute: { //返回主队列更新UI
                    //上下行1 dataModel数据model
                    self.busInfos.append(dataModel)
                   })
                   
                })
            }
            BusInfoWithRunPathID.startRequest(lineEnity.runPathId, flag:flags[1])
            { (dataModel) in
                busInfosQueue.async(execute:{
                    DispatchQueue.main.async(execute:{//返回主队列更新UI
                        //上下行3 dataModel数据model
                        self.busInfos.append(dataModel)
                    })
                })
            }
        }else
        {
            let cell = tableView.cellForRow(at: indexPath) as! BusLineInfoV2TableViewCell
            
            let busInfoDetailVC = BusInfoDetailViewController()
            busInfoDetailVC.runPathID = currectRunPathIdForBusInfo
            busInfoDetailVC.currentIndex = cell.changeDirectionBtn.isSelected ? 1 : 0
            busInfoDetailVC.hidesBottomBarWhenPushed = true
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SHOWSEARCHRESULTNOTIFICATION), object: self, userInfo:
                ["runPathID":currectRunPathIdForBusInfo,
                 "currentDirection":cell.changeDirectionBtn.isSelected ? 1 : 0,
                 "BusInfos":busInfos])
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

