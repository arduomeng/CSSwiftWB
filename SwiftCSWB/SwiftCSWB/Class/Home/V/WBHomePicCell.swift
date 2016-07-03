
//
//  WBHomePicCell.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class WBHomePicCell : UICollectionViewCell {
    
    
    
    @IBOutlet weak var picImageView: UIImageView!
    
    var picUrl : String?{
        didSet{
            
            if let url = picUrl {
                let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url)
                picImageView.image = image
            }
            
        }
    }
}