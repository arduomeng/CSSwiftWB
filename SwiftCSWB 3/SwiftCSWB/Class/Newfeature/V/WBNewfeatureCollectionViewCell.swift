//
//  WBNewfeatureCollectionViewCell.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBNewfeatureCollectionViewCell: UICollectionViewCell {
    
    deinit{
        print("newfeature")
    }
    
    lazy var imageView : UIImageView = {
       let image = UIImageView()
        image.frame = self.bounds
        return image
    }()
    
    lazy var welcomeBtn : UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "new_feature_button"), for: UIControlState())
        btn.setImage(UIImage(named: "new_feature_button_highlighted"), for: UIControlState.highlighted)
        
        var frame = btn.frame
        frame.size = (btn.currentImage?.size)!
        btn.frame = CGRect(x: (UIScreen.main.bounds.width - frame.size.width) * 0.5, y: UIScreen.main.bounds.height - 200, width: frame.size.width, height: frame.size.height)
        
        btn.addTarget(self, action: #selector(WBNewfeatureCollectionViewCell.welcomeBtnOnClick), for: UIControlEvents.touchUpInside)
        btn.isHidden = true;
        
        return btn
        
    }()
    
    var imageIndex : Int? {
        didSet{
            imageView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    func welcomeBtnOnClick(){
        // 发送通知，告诉appdelegate 切换控制器
        NotificationCenter.default.post(name: Notification.Name(rawValue: switchViewController), object: nil)
    }
    
    func startAnimation(){
        
        welcomeBtn.isHidden = false
        welcomeBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.welcomeBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
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
