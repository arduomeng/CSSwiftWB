//
//  WBHomePicCollection.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBHomePicCollection: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

    let reuseID = "picCell"
    
    var status : WBStatus? {
        didSet{
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.white
        isScrollEnabled = false
        register(UINib(nibName: "WBHomePicCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func picCollectionView(_ collectionViewLayout: UICollectionViewLayout) -> WBHomePicCollection{
        let collectionView : WBHomePicCollection = WBHomePicCollection(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        
        
        return collectionView
    }

}

extension WBHomePicCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return status?.pic_urls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : WBHomePicCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! WBHomePicCell
        
        let picStr = status?.pic_urls![indexPath.item]["thumbnail_pic"] as? String
        cell.picUrl = picStr
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bmiddle_pic = status?.bmiddle_pic
        // 发送通知给HomeViewController
        NotificationCenter.default.post(name: Notification.Name(rawValue: CSShowPhotoBrowserController), object: self, userInfo: ["bmiddle_pic" : bmiddle_pic!, "index" : indexPath.item])
    }
}
