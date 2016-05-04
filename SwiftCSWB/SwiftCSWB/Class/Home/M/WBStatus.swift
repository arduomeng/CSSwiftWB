//
//  WBStatus.swift
//  SwiftCSWB
//
//  Created by LCS on 16/5/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBStatus: NSObject{

    var created_at : String?
    var id : NSNumber?
    var source : String?
    var text : String?
    var pic_urls : [[String : AnyObject]]?
    var user : WBUser?
    
    init(dict : [String : AnyObject]){
        super.init()
    
        setValuesForKeysWithDictionary(dict)
    }
    
    // 对象中的属性和字典不完全匹配的时候要实现该方法，忽略找不到的key
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
        if key == "user"{
            let user = WBUser.init(dict: value as! [String : AnyObject])
            self.user = user
            
        }
    }
    
    override var description: String {
        let keys : [String] = ["created_at", "id", "source", "text", "pic_urls"]
        let dict = dictionaryWithValuesForKeys(keys)
        
        return ("\(dict)")
    }
    
    // 获取微博数据
    class func loadNewStatuses(finished : (dateArr : [WBStatus]?, error : NSError?) -> ()){
        let URL = "2/statuses/home_timeline.json"
        var params = [String : AnyObject]()
        if let account : WBOAuthAccount? = WBOAuthAccountTool.shareOAuthAccountTool().loadAccount(){
            params["access_token"] = account?.access_token
        }
        WBNetworkTool.shareNetworkOAuthTool().GET(URL, parameters: params, success: { (_, response) -> Void in
            
            if let JSON = response {
                // 字典数组转模型数组
                let statusArr : [WBStatus] = WBStatus.dictionaryArrToModelArr(JSON["statuses"]! as! [[String : AnyObject]])
                
                // 调用闭包给外部传值
                finished(dateArr: statusArr, error: nil)
            }
            
            }) { (_, error) -> Void in
                // 调用闭包给外部传值
                finished(dateArr: nil, error: error)
        }
    }
    class func dictionaryArrToModelArr(dictArr : [[String : AnyObject]]) -> [WBStatus]{
        var dateArr = [WBStatus]()
        for dict in dictArr{
            let status : WBStatus = WBStatus.init(dict: dict)
            dateArr.append(status)
        }
        return dateArr
    }
}
