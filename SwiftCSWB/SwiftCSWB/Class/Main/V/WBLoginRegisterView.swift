//
//  WBLoginRegisterView.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

@objc
protocol WBLoginRegisterViewDelegate : NSObjectProtocol {
    optional
    func WBLoginRegisterViewOnClickLoginBtn()
    func WBLoginRegisterViewOnClickRegisterBtn()
}

class WBLoginRegisterView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate : WBLoginRegisterViewDelegate?
    
    
    
    override func awakeFromNib() {
        contentView.backgroundColor = UIColor.yellowColor()
    }
    
    @IBAction func loginBtnOnClick(sender: AnyObject) {
        if let tempDelegate = delegate {
            if tempDelegate.respondsToSelector("WBLoginRegisterViewOnClickLoginBtn"){
                
                delegate?.WBLoginRegisterViewOnClickLoginBtn!()
            }
        }
    }
    
    @IBAction func registerBtnOnClick(sender: AnyObject) {
        delegate?.WBLoginRegisterViewOnClickRegisterBtn()
    }
}
