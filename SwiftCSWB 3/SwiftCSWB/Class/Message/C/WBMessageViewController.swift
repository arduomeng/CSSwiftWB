//
//  WBMessageViewController.swift
//  SwiftCSWB
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBMessageViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        
        loginRegisterView("visitordiscover_image_message", isPlayground: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
