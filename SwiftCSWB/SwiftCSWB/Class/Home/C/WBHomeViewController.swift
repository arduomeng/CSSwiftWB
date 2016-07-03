//
//  WBHomeViewController.swift
//  SwiftCSWB
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import SDWebImage


class WBHomeViewController: WBBaseViewController {

    let reusedID : String = "StatusCell"
    
    var mainTableView : UITableView?
    
    var statusArr : [WBStatus]?
    
    // titleView
    lazy var titleView : WBNavBarTitleView = {
        return WBNavBarTitleView()
    }()
    
    // 自定义转场代理
    lazy var Transitioning : WBTransitioningDelegate = {
        return WBTransitioningDelegate()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        setUpTableView()
        
        // 监听menuView的dismiss
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didObserverMenuViewDismiss", name: dismissMenuView, object: nil)
        
        let isLogin : Bool = loginRegisterView("visitordiscover_feed_image_house", isPlayground: false)
        
        if isLogin{
            WBStatus.loadNewStatuses({ (dateArr : [WBStatus]?, error : NSError?) -> () in
                if error != nil {
                    print(error)
                    return
                }
                
                self.statusArr = dateArr
                
                // 下载配图(下载完成后刷新表格)
                self.cachesImages(dateArr)
            })
        }
    }
    
    // 缓存微博配图
    private func cachesImages(modelArr : [WBStatus]?){
        
        // 创建线程队列组
        let group : dispatch_group_t = dispatch_group_create()
        
        if let modelArrTemp = modelArr {
            for model in modelArrTemp{
                // 取出pic_url字典数组
                if let pic_urlArr = model.pic_urls{
                    
                    // 下载这条微博中所有的配图
                    for picUrl in pic_urlArr{
                        if let urlStr = picUrl["thumbnail_pic"] as? String {
                            let url : NSURL = NSURL(string: urlStr)!
                            
                            // 将下载任务加入队列组
                            dispatch_group_enter(group)
                            
                            SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) -> Void in
                                CSprint("图片下载完成")
                                
                                // 将下载任务移除队列组
                                dispatch_group_leave(group)
                            })
                            
                        }
                    }
                    
                }
            }
            
            // 当队列组中的所有任务都执行完毕，并移除后，调用该方法
            dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
                CSprint("图片全部下载完毕")
                self.mainTableView?.reloadData()
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func didObserverMenuViewDismiss(){
        titleView.selected = !titleView.selected
    }
    
    func setUpNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithButton("navigationbar_friendattention", highLightImageName: "navigationbar_friendattention_highlighted", target: self, select: "userCenter")
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButtonItemWithButton("navigationbar_pop", highLightImageName: "navigationbar_pop_highlighted", target: self, select: "QRcode")
        
        
        navigationItem.titleView = titleView
        titleView.setTitle("安人多梦", forState: UIControlState.Normal)
        titleView.addTarget(self, action: "btnOnClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setUpTableView(){
        let rect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        let tableView = UITableView(frame: rect)
        // 代码创建的cell的注册方式
        // tableView.registerClass(WBHomeStatusTableViewCell.self, forCellReuseIdentifier: reusedID)
        // xib创建的cell的注册方式
        tableView.registerNib(UINib.init(nibName: "WBHomeStatusTableViewCell", bundle: nil), forCellReuseIdentifier: reusedID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        mainTableView = tableView
    }
    
    // 注意 事件响应函数不能用private 修饰。因为事件响应是通过runloop监听的，设置私有后runloop找不到该方法
    func btnOnClick(){
        titleView.selected = !titleView.selected
        
        // 自定义modal动画。版本iOS8 
        /*
            注意：默认的modal方式，会将原控制器的view先移除。
                 自定义modal样式，不会移除原来的控制器view
        */
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let menuVC = sb.instantiateViewControllerWithIdentifier("WBMenuViewController")
        // 设置modal代理 注意：因为代理delegate为弱指针，所以要用懒加载保存Transitioning
        menuVC.transitioningDelegate = Transitioning
        // 设置modal样式自定义
        menuVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(menuVC, animated:true , completion: nil)
    }
    
    
    func userCenter(){
        
    }
    
    func QRcode(){
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let QRcodeVC = sb.instantiateViewControllerWithIdentifier("WBQRcodeViewController")
        let QRcodeNavVC = UINavigationController(rootViewController: QRcodeVC)
        presentViewController(QRcodeNavVC, animated: true, completion: nil)
    }

}

extension WBHomeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 如果前面为nil，则返回0
        return statusArr?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(reusedID, forIndexPath: indexPath) as! WBHomeStatusTableViewCell
        
        // 因为能来到该代理方法，则statusArr?.count一定不为零，即statusArr一定有值
        cell.status = statusArr![indexPath.row];
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return statusArr![indexPath.row].cellHeight!
    }
}


