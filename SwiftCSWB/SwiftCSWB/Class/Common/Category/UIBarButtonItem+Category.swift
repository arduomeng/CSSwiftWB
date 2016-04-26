//
//  UIBarButtonItem+Category.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    class func barButtonItemWithButton(imageName: String, highLightImageName: String, target: AnyObject?, select: Selector) -> UIBarButtonItem{
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: highLightImageName), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: select, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: btn)
    }
    
}