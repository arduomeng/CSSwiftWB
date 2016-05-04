//
//  WBBaseViewController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBBaseViewController: UIViewController, WBLoginRegisterViewDelegate {

    var isLogin : Bool?

    lazy var loginRegisterView:WBLoginRegisterView = {
        let lrView = NSBundle.mainBundle().loadNibNamed("WBLoginRegisterView", owner: nil, options: nil).last as! WBLoginRegisterView
        
        lrView.frame = CGRect(x: 0, y: 0, width: 414, height: 736)
        
        return lrView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isLogin = isLoginAndValid()
    }
    
    // 判断是非登陆，且没有过期
    func isLoginAndValid() -> Bool{
        let account = WBOAuthAccountTool.shareOAuthAccountTool().loadAccount()
        if (account != nil)  && (account?.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending){

            return true
        }
        return false
    }
    
    func loginRegisterView(image: String, isPlayground: Bool) -> Bool{
        if isLogin == false {
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
            return false
        }
        return true
    }
    
    // MARK: -WBLoginRegisterViewDelegate
    func WBLoginRegisterViewOnClickLoginBtn() {
        // OAuth授权登录
        let OAuthVC = WBOAuthViewController()
        let OAuthNav = UINavigationController(rootViewController: OAuthVC)
        self.presentViewController(OAuthNav, animated: true, completion: nil)
    }
    func WBLoginRegisterViewOnClickRegisterBtn() {
        
    }

}
