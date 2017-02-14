//
//  UIBarButtonItem+Category.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    
    class func barButtonItemWithButton(_ imageName: String, highLightImageName: String, target: AnyObject?, select: Selector) -> UIBarButtonItem{
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        btn.setImage(UIImage(named: highLightImageName), for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
    
}
