//
//  WBHomeViewController.swift
//  SwiftCSWB
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBHomeViewController: WBBaseViewController {

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

        view.backgroundColor = UIColor.redColor()
        
        setUpNavBar()
        
        // 监听menuView的dismiss
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didObserverMenuViewDismiss", name: dismissMenuView, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loginRegisterView("visitordiscover_feed_image_house", isPlayground: false)
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


