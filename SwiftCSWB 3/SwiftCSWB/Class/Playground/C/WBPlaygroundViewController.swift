//
//  WBPlaygroundViewController.swift
//  SwiftCSWB
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBPlaygroundViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        
        loginRegisterView("visitordiscover_feed_image_smallicon", isPlayground: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    


}
