//
//  WBPresentationController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBPresentationController: UIPresentationController {
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /*
        containerView : 容器视图 (存放被展示的视图)
        presentedView : 被展示的视图 (modal出来的控制器view)
    */
    override func containerViewWillLayoutSubviews(){
        let W = CGFloat(100)
        let H = CGFloat(200)
        let X = UIScreen.main.bounds.size.width * 0.5 - W * 0.5
        let Y = CGFloat(64)
        presentedView?.frame = CGRect(x: X, y: Y, width: W, height: H)
        
        // 创建蒙板
        let maskView = UIView()
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.1
        maskView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let tap = UITapGestureRecognizer(target: self, action: #selector(WBPresentationController.maskViewOnClick))
        maskView.addGestureRecognizer(tap)
        containerView?.insertSubview(maskView, belowSubview: presentedView!)
        
    }
    
    func maskViewOnClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
