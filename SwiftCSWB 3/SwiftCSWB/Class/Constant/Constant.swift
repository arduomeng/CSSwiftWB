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
let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
let accountFilePath = (cachePath! as NSString).appendingPathComponent("account.arch")


func CSprint<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

// 通知
let CSShowPhotoBrowserController = "CSShowPhotoBrowserController"
