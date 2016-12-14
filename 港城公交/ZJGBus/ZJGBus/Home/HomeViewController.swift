//
//  HomeViewController.swift
//  ZJGBus
//
//  Created by EagleMan on 2016/12/12.
//  Copyright © 2016年 Eagle. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate
{
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    var collections : [BusOnlineEntity]?
    let  circleLayer = CAShapeLayer()//点击搜索按钮的辐射动画图层
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.homeTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //没有收藏的时候默认的背景
        let backgroundImageView = UIImageView(image:#imageLiteral(resourceName: "HomeTBBac"))
        backgroundImageView.contentMode = .scaleAspectFit
        self.homeTableView.backgroundView = backgroundImageView
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func goToSearchVC(_ sender: Any)
    {
        //坐标系和正常的坐标系不一样,所以是这样渲染的
        
        //开始图形路径
        let fromPath = UIBezierPath(arcCenter:CGPoint(x:170,y:667) , radius: 50, startAngle:CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise:true)
        
        circleLayer.path = fromPath.cgPath
        //shapeLayer.strokeColor = UIColor.red.cgColor
        circleLayer.fillColor = UIColor(colorLiteralRed: 254/255, green: 228/255, blue: 227/255, alpha: 1).cgColor
        self.view.layer.addSublayer(circleLayer)
        
        //结束的图形路径
        let toPath = UIBezierPath(arcCenter:CGPoint(x:170,y:300), radius: 1000, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        let fillAnimation = CABasicAnimation(keyPath: "path")
        fillAnimation.fillMode = kCAFillModeForwards
        fillAnimation.isRemovedOnCompletion = false
        //fillAnimation.fromValue = fromPath
        fillAnimation.toValue = toPath.cgPath
        fillAnimation.duration = 1
        fillAnimation.delegate = self
        fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        //fillAnimation.setValue(shapeLayer, forKey:"circle")
        circleLayer.add(fillAnimation, forKey: "path")
        
        //颜色渐变动画
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.fillMode = kCAFillModeForwards
        colorAnimation.toValue = UIColor(colorLiteralRed: 167/255, green: 177/255, blue: 246/255, alpha: 1).cgColor
       // colorAnimation.toValue = UIColor.white.cgColor
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.duration = 1
        colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        circleLayer.add(colorAnimation, forKey: "color")
        
        
        self.navigationController?.pushViewController(ViewController(), animated: true)
        
    }
   //MARK: animation delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        circleLayer.removeFromSuperlayer()
    }
    //MARK: table datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let rows = collections?.count
        {
               return rows
        }else
        {
               return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "1")
        if let reuseCell = cell
        {
           return reuseCell
        }else
        {
             cell = UITableViewCell(style: .default, reuseIdentifier: "1")
             return cell!
        }
    }
}
