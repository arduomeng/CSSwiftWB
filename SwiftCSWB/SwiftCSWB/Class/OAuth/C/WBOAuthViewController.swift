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
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        return webView
    }()
    
    override func loadView() {
        self.view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Done, target: self, action: "dismissVC")
          
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        let URL = NSURL(string: url)
        let URLRequest = NSURLRequest(URL: URL!)
        webview.loadRequest(URLRequest)
        
        webview.delegate = self
        
    }
    func dismissVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension WBOAuthViewController : UIWebViewDelegate{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let codeStr = "code="
        
        if (request.URL?.absoluteString)!.hasPrefix(redirect_uri) && (request.URL?.query)!.hasPrefix(codeStr){
            let code = (request.URL?.query)!.substringFromIndex(codeStr.endIndex)
            
            // 根据code换取AccessToken
            AccessToken(code)
        }
        
        if (request.URL?.absoluteString)!.hasPrefix(redirect_uri){
            return false
        }
        return true
    }
    
    func AccessToken(code : String){
        
        
        let networkOAuth = WBNetworkTool.shareNetworkOAuthTool()
        let path = "oauth2/access_token"
        var params = [String : AnyObject]()
        params["client_id"] = client_id
        params["client_secret"] = AppSecret
        params["grant_type"] = "authorization_code"
        params["redirect_uri"] = redirect_uri
        params["code"] = code
        
        networkOAuth.POST(path, parameters: params, success: { (_, JSON) -> Void in
          
            // 获取用户信息
            self.getUserInfo(JSON as! [String : AnyObject])
            
            }) { (_, error) -> Void in
                print(error)
        }
        
        
    }
    
    func getUserInfo(JSON : [String : AnyObject]){
        let accountJSON = JSON
        let networkOAuth = WBNetworkTool.shareNetworkOAuthTool()
        let path = "2/users/show.json"
        var params = [String : AnyObject]()
        params["access_token"] = JSON["access_token"]
        params["uid"] = JSON["uid"]
        
        networkOAuth.GET(path, parameters: params, success: { (_, userInfoJSON) -> Void in
    
            // 初始化对象
            let OAuthAccount = WBOAuthAccount(dict: accountJSON)
            // 添加需要的个人信息
            if let userInfo = userInfoJSON {
                OAuthAccount.screen_name = userInfo["screen_name"] as! String
                OAuthAccount.profile_image_url = userInfo["profile_image_url"] as! String
            }
            // 归档操作
            WBOAuthAccountTool.shareOAuthAccountTool().saveAccount(OAuthAccount)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            // 发送通知，让appdelegate切换控制器
            NSNotificationCenter.defaultCenter().postNotificationName(switchViewController, object: nil)
            
            
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showInfoWithStatus("登录中...", maskType: SVProgressHUDMaskType.Black)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}
