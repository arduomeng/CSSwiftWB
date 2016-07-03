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
            
            self.textLabel.text = "@\(status?.user?.screen_name):\(status?.text)"
            
        }
    }
}
