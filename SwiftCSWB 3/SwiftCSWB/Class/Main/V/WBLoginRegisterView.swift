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
    @objc optional
    func WBLoginRegisterViewOnClickLoginBtn()
    func WBLoginRegisterViewOnClickRegisterBtn()
}

class WBLoginRegisterView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate : WBLoginRegisterViewDelegate?
    
    
    
    override func awakeFromNib() {
        contentView.backgroundColor = UIColor.yellow
    }
    
    @IBAction func loginBtnOnClick(_ sender: AnyObject) {
        if let tempDelegate = delegate {
            if tempDelegate.responds(to: #selector(WBLoginRegisterViewDelegate.WBLoginRegisterViewOnClickLoginBtn)){
                
                delegate?.WBLoginRegisterViewOnClickLoginBtn!()
            }
        }
    }
    
    @IBAction func registerBtnOnClick(_ sender: AnyObject) {
        delegate?.WBLoginRegisterViewOnClickRegisterBtn()
    }
}
