//
//  WBNewfeatureCollectionViewController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

// 版本一

private let reuseIdentifier = "Cell"
private let reuseIdentifier = "masterTemp"

class WBNewfeatureCollectionViewController: UICollectionViewController {

    private let layout : WBNewfeatureLayout = WBNewfeatureLayout()
    // 因为系统指定的collectionView的构造方法是带参数(collectionViewLayout)的,所以这里重写init不需要override
    init(){
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 注册cell
        collectionView?.registerClass(WBNewfeatureCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       
        let cell : WBNewfeatureCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! WBNewfeatureCollectionViewCell
        
        cell.backgroundColor = UIColor.blueColor()
        cell.imageIndex = indexPath.item

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 获取显示的cell的indexPath
        let itemIndex = collectionView.indexPathsForVisibleItems().last
        
        if itemIndex?.item == 3 {
            let cell = collectionView.cellForItemAtIndexPath(itemIndex!) as! WBNewfeatureCollectionViewCell
            cell.startAnimation()
        }
    }

}

// 自定义布局
private class WBNewfeatureLayout : UICollectionViewFlowLayout{
    
    // 准备布局 调用时间 1.确定多少行cell 2.调用prepareLayout 3.返回cell
    private override func prepareLayout() {
        // 设置layout布局
        // item的大小
        itemSize = UIScreen.mainScreen().bounds.size
        // 间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 设置collectionView属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        // 超出不可滚动
        collectionView?.bounces = false
    }
}
