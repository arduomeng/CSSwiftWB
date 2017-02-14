//
//  WBOAuthAccount.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBOAuthAccount: NSObject, NSCoding{
    
    
    // 帐号信息
    var access_token : String?
    var expires_in : NSNumber?
    var remind_in : String?
    var uid : String?
    
    // 个人信息
    var screen_name : String?
    var profile_image_url : String?
    
    // 过期时间
    var expiresDate : Date?
    
    override init() {
        super.init()
    }
    
    init(dict:[String : AnyObject]) {
        
        super.init()
        
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        remind_in = dict["remind_in"] as? String
        uid = dict["uid"] as? String
        
        // 记录accessToken的过期时间
        expiresDate =  Date(timeIntervalSinceNow: expires_in!.doubleValue)
        
    }
    
    // 重写description属性的getter方法
    override var description : String{
        // 属性数组
        let keys = ["access_token", "expires_in", "remind_in", "uid", "screen_name", "profile_image_url", "expiresDate"]
        // 将属性数组转换成字典
        let dict = self.dictionaryWithValues(forKeys: keys)
        
        return "\(dict)"
    }
    

    
    func encode(with aCoder: NSCoder){
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(remind_in, forKey: "remind_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expiresDate, forKey: "expiresDate")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(profile_image_url, forKey: "profile_image_url")
    }
    required init?(coder aDecoder: NSCoder){
        access_token =  aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
        remind_in = aDecoder.decodeObject(forKey: "remind_in") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        profile_image_url = aDecoder.decodeObject(forKey: "profile_image_url") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? Date
    }
    
    
}
