//
//  WBHomeRefreshView.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

// 下拉刷新控件
class WBHomeRefreshControl : UIRefreshControl{
    
    lazy var refreshView : WBHomeRefreshView = WBHomeRefreshView.refreshView()
    
    override init() {
        super.init()
        // 添加视图
//        addSubview(refreshView)
        
        // 设置尺寸
//        refreshView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


// 下拉刷新视图
class WBHomeRefreshView: UIView {

    class func refreshView() -> WBHomeRefreshView{
        
        let refresh : WBHomeRefreshView = NSBundle.mainBundle().loadNibNamed("WBHomeRefreshView", owner: nil, options: nil).last as! WBHomeRefreshView
        
        return refresh
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing.None
    }

}
