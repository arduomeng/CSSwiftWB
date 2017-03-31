//
//  WBOAuthViewController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    
    deinit{
        print("oauth deinit")
    }
    
    lazy var webview : UIWebView = {
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return webView
    }()
    
    override func loadView() {
        self.view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.done, target: self, action: #selector(WBOAuthViewController.dismissVC))
          
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        let URL = Foundation.URL(string: url)
        let URLRequest = Foundation.URLRequest(url: URL!)
        webview.loadRequest(URLRequest)
        
        webview.delegate = self
        
    }
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension WBOAuthViewController : UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let codeStr = "code="
        
        if (request.url?.absoluteString)!.hasPrefix(redirect_uri) && (request.url?.query)!.hasPrefix(codeStr){
            let code = (request.url?.query)!.substring(from: codeStr.endIndex)
            
            // 根据code换取AccessToken
            AccessToken(code)
        }
        
        if (request.url?.absoluteString)!.hasPrefix(redirect_uri){
            return false
        }
        return true
    }
    
    func AccessToken(_ code : String){
        
        
        let networkOAuth = WBNetworkTool.shareNetworkOAuthTool()
        let path = "oauth2/access_token"
        var params = [String : AnyObject]()
        params["client_id"] = client_id as AnyObject?
        params["client_secret"] = AppSecret as AnyObject?
        params["grant_type"] = "authorization_code" as AnyObject?
        params["redirect_uri"] = redirect_uri as AnyObject?
        params["code"] = code as AnyObject?
        
        networkOAuth.post(path, parameters: params, success: { (_, JSON) -> Void in
          
            // 获取用户信息
            self.getUserInfo(JSON as! [String : AnyObject])
            
            }) { (_, error) -> Void in
                print(error)
        }
        
        
    }
    
    func getUserInfo(_ JSON : [String : AnyObject]){
        let accountJSON = JSON
        let networkOAuth = WBNetworkTool.shareNetworkOAuthTool()
        let path = "2/users/show.json"
        var params = [String : AnyObject]()
        params["access_token"] = JSON["access_token"]
        params["uid"] = JSON["uid"]
        
        networkOAuth.get(path, parameters: params, progress: nil, success: { (_, userInfoJSON) in
            // 初始化对象
            let OAuthAccount = WBOAuthAccount(dict: accountJSON)
            // 添加需要的个人信息
            if let userInfo = userInfoJSON {
                OAuthAccount.screen_name = (userInfo as! [String : AnyObject])["screen_name"] as? String
                OAuthAccount.profile_image_url = (userInfo as! [String : AnyObject])["profile_image_url"] as? String
            }
            // 归档操作
            WBOAuthAccountTool.shareOAuthAccountTool().saveAccount(OAuthAccount)
            
            self.dismiss(animated: true, completion: nil)
            // 发送通知，让appdelegate切换控制器
            NotificationCenter.default.post(name: Notification.Name(rawValue: switchViewController), object: nil)
        }) { (_, error) in
            print(error)
        }
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        SVProgressHUD.showInfo(withStatus: "登录中...")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        SVProgressHUD.dismiss()
    }
    
    
}
