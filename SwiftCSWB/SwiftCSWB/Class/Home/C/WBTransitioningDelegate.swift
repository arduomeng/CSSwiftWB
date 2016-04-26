//
//  WBTransitioningDelegate.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBTransitioningDelegate: NSObject {

    lazy var AnimatedTransitioning : WBAnimatedTransitioning = {
        return WBAnimatedTransitioning()
    }()
    
}

// 代理方法
extension WBTransitioningDelegate : UIViewControllerTransitioningDelegate{
    /**
     告诉系统谁来负责转场(设置被modal出来的控制器view的frame)
     
     - parameter presented:  被modal出来的控制器
     - parameter presenting: 原控制器
     - parameter source:
     
     - returns: 负责转场动画对象
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        // 返回控制转场动画对象
        return WBPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // 当实现下面两个动画方法后，modal动作中所有的操作都需要自己实现(包括将被modal的view添加到containerView上)
    
    /**
    modal 的展现动画(设置被modal出来的控制器view的动画)
    
    - parameter presented:
    - parameter presenting:
    - parameter source:
    
    - returns:
    */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        AnimatedTransitioning.isShow = false;
        return AnimatedTransitioning
    }
    /**
     modal 的消失动画
     
     - parameter dismissed:
     
     - returns:
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        AnimatedTransitioning.isShow = true;
        
        // 发送通知，设置箭头向上
        NSNotificationCenter.defaultCenter().postNotificationName(dismissMenuView, object: self)
        
        return AnimatedTransitioning
    }
    
    
}