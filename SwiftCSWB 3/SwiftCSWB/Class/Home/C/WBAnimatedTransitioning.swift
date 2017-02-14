//
//  WBAnimatedTransitioning.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBAnimatedTransitioning: NSObject {

    // 被modal的view是否显示
    var isShow = false
    
}

extension WBAnimatedTransitioning:UIViewControllerAnimatedTransitioning{
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        
        /*
            当展开的时候被modal出来的view是toView
            当消失的时候被modal出来的view是fromView
        */
        
        if isShow{
            
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            // 执行动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                fromView?.transform = CGAffineTransform(scaleX: 1, y: 0.000001)
                }, completion: { (_) -> Void in
                    fromView?.removeFromSuperview()
                    //动画执行完后调用该方法，告诉系统
                    transitionContext.completeTransition(true)
            })
            
        }else{
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            // 被modal出来的view添加到containerView上
            transitionContext.containerView.addSubview(toView!)
            
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            toView?.transform = CGAffineTransform(scaleX: 1, y: 0)
            
            // 执行动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                toView?.transform = CGAffineTransform.identity
                }, completion: { (_) -> Void in
                    //动画执行完后调用该方法，告诉系统
                    transitionContext.completeTransition(true)
            })
            
        }
        
        
    }
}
