//
//  WBPhotoBrowserViewController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/11/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class WBPhotoBrowserViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var picsUrl : [NSURL]?
    var index   : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // UI
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
//    init(picsUrl : [NSURL], index : Int){
//        
//        super.init(nibName: nil, bundle: nil)
//        
//    }

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private func setupUI(){
        flowLayout.itemSize = UIScreen.mainScreen().bounds.size
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: "PhotoBrowserCell")
    }
    
    @IBAction func closeOnclick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveOnclick(sender: AnyObject) {
    }
}

extension WBPhotoBrowserViewController : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoBrowserCell", forIndexPath: indexPath) as! PhotoBrowserCell
        cell.imageUrl = picsUrl![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picsUrl?.count ?? 0
    }
}

extension WBPhotoBrowserViewController : UICollectionViewDelegate{
    
}

class PhotoBrowserCell : UICollectionViewCell {
    
    var imageUrl : NSURL?{
        didSet{
            
            // 重置cell中控件的属性，解决cell重用时候的bug
            resetScrollView()
            
            imageView.sd_setImageWithURL(imageUrl, placeholderImage: nil) { (image, error, _, _) -> Void in
                // 获取图片尺寸计算frame
                let rate = image.size.width / image.size.height
                let imageW = UIScreen.mainScreen().bounds.width
                let imageH = imageW / rate
                
                // 设置imageView frame
                self.imageView.frame = CGRect(x: 0, y: 0, width: imageW, height: imageH)
                
                // 长图处理
                if imageH > UIScreen.mainScreen().bounds.height{
                    // 设置contentSize
                    self.scrollView.contentSize = CGSizeMake(0, imageH)
                }else{
                    // 设置contentInset
                    let insetMargin = (UIScreen.mainScreen().bounds.height - imageH) * 0.5
                    self.scrollView.contentInset = UIEdgeInsetsMake(insetMargin, 0, insetMargin, 0)
                    
                    // 由于cell重用， 需要设置contentSize
                    self.scrollView.contentSize = CGSizeMake(0, 0)
                }
                
            }
        }
    }
    
    private lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.maximumZoomScale = 2.0
        sv.minimumZoomScale = 0.5
        sv.delegate = self
        return sv
    }()
    private lazy var imageView : UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.backgroundColor = UIColor.purpleColor()
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = UIScreen.mainScreen().bounds
    }
    
    private func resetScrollView(){
        // 缩放时候系统会改变scrollView的以下属性， 恢复scrollView
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
        // 缩放时候系统会改变transform， 恢复缩放后的imageView
        imageView.transform = CGAffineTransformIdentity
    }
}

extension PhotoBrowserCell : UIScrollViewDelegate{
    // 需要缩放的view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // 设置contentInset 使缩小时候图片居中
        let screenW = UIScreen.mainScreen().bounds.width
        let screenH = UIScreen.mainScreen().bounds.height
        
        // 计算缩放时候的offset
        // 注意缩放时frame的值变化，而bounds的值不变。且系统会将scrollView的contentSize设置为该frame
        CSprint(imageView.frame)
        CSprint(scrollView.contentSize)
        
        var offsetX = (screenW - imageView.frame.width) * 0.5
        var offsetY = (screenH - imageView.frame.height) * 0.5
        
        // 当iamgeview放大时，防止offset出现负值导致无法滚动
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
        
    }
}



