//
//  WBNetworkOAuthTool.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import AFNetworking


class WBNetworkOAuthTool: AFHTTPSessionManager {
    
    static let networkTool : WBNetworkOAuthTool = {
        let URL = NSURL(string: "https://api.weibo.com/")
        let network = WBNetworkOAuthTool(baseURL: URL)
        return network
    }()
    
    // 创建一个单利
    class func shareNetworkOAuthTool () -> WBNetworkOAuthTool {
        return networkTool
    }
}
