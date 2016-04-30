//
//  WBOAuthAccountTool.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBOAuthAccountTool: NSObject {

    // 用户信息
    var OAuthAccount : WBOAuthAccount?
    
    static let OAuthAccountTool : WBOAuthAccountTool = WBOAuthAccountTool()
    
    class func shareOAuthAccountTool() -> WBOAuthAccountTool{
        return OAuthAccountTool
    }
    
    func saveAccount(account : WBOAuthAccount){
        NSKeyedArchiver.archiveRootObject(account, toFile: accountFilePath)
    }
    
    // 由于账号信息可能不存在unarchiveObjectWithFile -> AnyObject?    因此返回值为WBOAuthAccount?
    func loadAccount() -> WBOAuthAccount?{
        if OAuthAccount != nil {
            return OAuthAccount
        }
        OAuthAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountFilePath) as? WBOAuthAccount
        return OAuthAccount
    }
    
}
