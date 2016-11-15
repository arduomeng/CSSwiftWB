//
//  Constant.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

import Foundation


// cell 高度
let cellMargin = 10
let iconH = 50
let bottomBarH = 40

// 通知名
let dismissMenuView = "dismissMenuView" as String
let switchViewController = "switchViewController" as String;
// OAuth授权
let client_id = "2733386379"
let redirect_uri = "http://www.baidu.com"
let AppSecret = "b035745fd1c454cbc1df78a7bca98eb5"

// account路径 注意：cachePath! as NSString     stringByAppendingPathComponent是NSString的方法
let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
let accountFilePath = (cachePath! as NSString).stringByAppendingPathComponent("account.arch")


func CSprint<T>(message: T, fileName: String = __FILE__, methodName: String = __FUNCTION__, lineNumber: Int = __LINE__)
{
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

// 通知
let CSShowPhotoBrowserController = "CSShowPhotoBrowserController"
