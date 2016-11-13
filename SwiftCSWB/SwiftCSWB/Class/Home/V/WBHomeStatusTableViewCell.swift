//
//  WBHomeStatusTableViewCell.swift
//  SwiftCSWB
//
//  Created by LCS on 16/7/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import SDWebImage




class WBHomeStatusTableViewCell: UITableViewCell {

    let reuseID = "picCell"
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var verifyImageView: UIImageView!
    
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    // collectionViewFlowLayout
    lazy var collectionViewFlowLayout : UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        
        // 设置行间距
        flowLayout.minimumLineSpacing = 10
        // 列间距的最小值(实际间距会根据sectionInset、itemSize、collectionView自动计算)
        flowLayout.minimumInteritemSpacing = 0
        
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return flowLayout
    }()
    
    // 转发微博背景
    lazy var forwordBgView: WBHomeForwordCellBg = {
       let view = NSBundle.mainBundle().loadNibNamed("WBHomeForwordCellBg", owner: nil, options: nil).last as! WBHomeForwordCellBg
        self.mainView.addSubview(view)
        return view
    }()
    
    // 配图collectionView
    lazy var picCollectionView : WBHomePicCollection = {
        let collectionView : WBHomePicCollection = WBHomePicCollection(frame: CGRectZero, collectionViewLayout: self.collectionViewFlowLayout)
        // 布局
        self.mainView.addSubview(collectionView)
        
        return collectionView
    }()
    
    
    
    var status : WBStatus?{
        didSet{
            // 头像
            if let url = status?.user?.profile_image_url{
                let urlStr = NSURL(string: url)
                iconImageView.sd_setImageWithURL(urlStr)
            }
            
            // 认证
            var verifyImage : String?
            if let verify = status?.user?.verified_type{
                switch verify{
                case 0:
                    verifyImage = "avatar_enterprise_vip"
                case 2,3,5:
                    verifyImage = "avatar_vip"
                case 220:
                    verifyImage = "avatar_grassroot"
                default:
                    verifyImage = nil
                }
            }
            if let verifyName = verifyImage{
                verifyImageView.image = UIImage(named: verifyName)
            }else{
                verifyImageView.image = nil
            }
            // 会员
            if let rank = status?.user?.mbrank{
                if (rank >= 1 && rank <= 6){
                    vipImageView.image = UIImage(named: "common_icon_membership_level\(rank)")
                    nameLabel.textColor = UIColor.orangeColor()
                }
                else{
                    vipImageView.image = nil
                    nameLabel.textColor = UIColor.blackColor()
                }
            }
            
            
            // 昵称
            nameLabel.text = status?.user?.screen_name
            
            // 来源
            sourceLabel.text = status?.source
            // 时间
            timeLabel.text = status?.created_at
            // 正文
            contentLabel.text = status?.text
            
            // 设置头像圆角
            iconImageView.layer.cornerRadius = 25
            
            // 添加转发微博背景view
            if status?.forwordStatus?.pic_urls?.count > 0{
                forwordBgView.hidden = false
                forwordBgView.frame = (status?.forwordBgF)!
                forwordBgView.status = status?.forwordStatus
                
            }else{
                forwordBgView.hidden = true
            }
            
            // 添加配图view
            if status?.pic_urls?.count > 0{
                picCollectionView.hidden = false
                picCollectionView.frame = (status?.picF)!
                collectionViewFlowLayout.itemSize = status!.picItemSize!
                
                // 给collectionView传递模型
                picCollectionView.status = status
                
                
            }else{
                picCollectionView.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置正文的最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 10;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WBHomeStatusTableViewCell : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return status?.pic_urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell : WBHomePicCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseID, forIndexPath: indexPath) as! WBHomePicCell
        
        let picStr = status?.pic_urls![indexPath.item]["thumbnail_pic"] as? String
        cell.picUrl = picStr
        
        return cell
    }
}


