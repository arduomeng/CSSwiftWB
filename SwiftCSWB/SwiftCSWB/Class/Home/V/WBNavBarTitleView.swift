//
//  WBNavBarTitleView.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBNavBarTitleView: UIButton {

    // 目的：想在系统计算和设置完按钮的尺寸后，再修改一下尺寸
    /**
    *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
    *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
    */
    
    
    let margin = CGFloat(10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        self.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(19)
        
        self.sizeToFit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        self.sizeToFit()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = (imageView?.frame.origin.x)!
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + margin
        
    }

}
