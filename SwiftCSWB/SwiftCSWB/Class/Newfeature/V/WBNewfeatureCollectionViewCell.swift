//
//  WBNewfeatureCollectionViewCell.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBNewfeatureCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView : UIImageView = {
       let image = UIImageView()
        image.frame = self.bounds
        return image
    }()
    
    lazy var welcomeBtn : UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        
        var frame = btn.frame
        frame.size = (btn.currentImage?.size)!
        btn.frame = CGRect(x: (UIScreen.mainScreen().bounds.width - frame.size.width) * 0.5, y: UIScreen.mainScreen().bounds.height - 200, width: frame.size.width, height: frame.size.height)
        
        btn.addTarget(self, action: "welcomeBtnOnClick", forControlEvents: UIControlEvents.TouchUpInside)
        btn.hidden = true;
        
        return btn
        
    }()
    
    var imageIndex : Int? {
        didSet{
            imageView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    func welcomeBtnOnClick(){
        print("---")
    }
    
    func startAnimation(){
        
        welcomeBtn.hidden = false
        welcomeBtn.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(3.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.welcomeBtn.transform = CGAffineTransformMakeScale(1, 1)
            }) { (_) -> Void in
                
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(welcomeBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
