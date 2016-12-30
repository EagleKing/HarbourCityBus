//
//  CollectionsViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 2016/12/29.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit
import CoreData
class CollectionsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var collectionTableView: UITableView!
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    var busInfoCoupes : [[BusInfoWithRunPathID]]?
    @IBAction func back(_ sender: UIButton) {
        super.goBack()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
        collectionTableView.separatorStyle = .none
        busInfoCoupes = [[BusInfoWithRunPathID]]()
        self.navigationController?.navigationBar.isHidden = true
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BusInfoEntity")
        let sortDescriptor = NSSortDescriptor(key: "runPathName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: delegate.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
            
            let busInfoEntities = fetchedResultsController?.fetchedObjects as! [BusInfoEntity]
            
            
            //合并相同线路的上下线
            for (index,busInfoEntity) in busInfoEntities.enumerated()
            {
                if index % 2 == 0
                {
                    let busInfo  = BusInfoWithRunPathID()
                    busInfo.busInterval = busInfoEntity.busInterval!
                    busInfo.endStation = busInfoEntity.endStation!
                    busInfo.endTime = busInfoEntity.endTime!
                    busInfo.endTime1 = busInfoEntity.endTime1!
                    busInfo.runFlag = busInfoEntity.runFlag!
                    busInfo.runPathName = busInfoEntity.runPathName!
                    busInfo.startStation = busInfoEntity.startStation!
                    busInfo.startTime = busInfoEntity.startTime!
                    busInfo.startTime1 = busInfoEntity.startTime1!
                    busInfo.runPathID = busInfoEntity.runPathID
                    let busInfo2 = BusInfoWithRunPathID()
                    let busInfoEntity2 = busInfoEntities[index+1]
                    
                    busInfo2.busInterval = busInfoEntity2.busInterval!
                    busInfo2.endStation = busInfoEntity2.endStation!
                    busInfo2.endTime = busInfoEntity2.endTime!
                    busInfo2.endTime1 = busInfoEntity2.endTime1!
                    busInfo2.runFlag = busInfoEntity2.runFlag!
                    busInfo2.runPathName = busInfoEntity2.runPathName!
                    busInfo2.startStation = busInfoEntity2.startStation!
                    busInfo2.startTime = busInfoEntity2.startTime!
                    busInfo2.startTime1 = busInfoEntity2.startTime1!
                    busInfo2.runPathID = busInfoEntity2.runPathID
                    
                    
                    busInfoCoupes?.append([busInfo,busInfo2])
                }
            }
            
            
            
        } catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
        
        collectionTableView.register(UINib.init(nibName:"BusLineInfoV2TableViewCell", bundle: nil), forCellReuseIdentifier: BusLineInfoV2CellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (busInfoCoupes?.count)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BusLineInfoV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: BusLineInfoV2CellID, for: indexPath) as! BusLineInfoV2TableViewCell
        cell.busInfos  = (busInfoCoupes?[indexPath.row])!
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            collectionTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = collectionTableView.cellForRow(at: indexPath!) as! BusLineInfoV2TableViewCell
            cell.busInfos  = [fetchedResultsController?.fetchedObjects![(indexPath?.row)!] as! BusInfoWithRunPathID]
        case .move:
            collectionTableView.deleteRows(at: [indexPath!], with: .automatic)
            collectionTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BusLineInfoV2TableViewCell
        let busInfos : [BusInfoWithRunPathID] = busInfoCoupes![indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SHOWSEARCHRESULTNOTIFICATION), object: self, userInfo:
            ["runPathID": busInfos[0].runPathID as Any,
             "currentDirection":cell.changeDirectionBtn.isSelected ? 1 : 0,
             "BusInfos":busInfoCoupes?[indexPath.row] as Any])
     let _ =   self.navigationController?.popViewController(animated: true)
    }
}
