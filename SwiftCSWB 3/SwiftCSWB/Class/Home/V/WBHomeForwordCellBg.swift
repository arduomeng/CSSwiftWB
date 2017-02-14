//
//  WBHomeForwordCellBg.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBHomeForwordCellBg: UIView {

    
    @IBOutlet weak var textLabel: UILabel!

    var status : WBStatus?{
        didSet{
            
            if let text = status?.text {
                let name = status?.user?.screen_name ?? ""
                self.textLabel.text = "@" + name + ":" + text
            }
        }
    }
}
