//
//  WBBaseViewController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController, WBLoginRegisterViewDelegate {

    var isLogin = false;

    lazy var loginRegisterView:WBLoginRegisterView = {
        let lrView = NSBundle.mainBundle().loadNibNamed("WBLoginRegisterView", owner: nil, options: nil).last as! WBLoginRegisterView
        
        lrView.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
        
        return lrView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loginRegisterView(image: String, isPlayground: Bool){
        if !isLogin {
            view.addSubview(self.loginRegisterView)
            
            // 设置delegate
            self.loginRegisterView.delegate = self;
            
            loginRegisterView.imageView.image = UIImage(named: image)
            
            // MARK: - 判断是否是广场控制器，设置动画
            if isPlayground{
                let animation = CABasicAnimation(keyPath: "transform.rotation")
                animation.duration = 10
                animation.toValue = 2 * M_PI
                animation.repeatCount = MAXFLOAT
                loginRegisterView.imageView.layer.addAnimation(animation, forKey: nil)
                
            }
        }
    }
    
    // MARK: -WBLoginRegisterViewDelegate
    func WBLoginRegisterViewOnClickLoginBtn() {
        print("login")
    }
    func WBLoginRegisterViewOnClickRegisterBtn() {
        print("register")
    }

}
