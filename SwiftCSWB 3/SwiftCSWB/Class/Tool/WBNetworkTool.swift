//
//  WBNetworkOAuthTool.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import AFNetworking


class WBNetworkTool: AFHTTPSessionManager {
    
    static let networkTool : WBNetworkTool = {
        let URL = Foundation.URL(string: "https://api.weibo.com/")
        let network = WBNetworkTool(baseURL: URL)
        return network
    }()
    
    // 创建一个单利
    class func shareNetworkOAuthTool () -> WBNetworkTool {
        return networkTool
    }
}
