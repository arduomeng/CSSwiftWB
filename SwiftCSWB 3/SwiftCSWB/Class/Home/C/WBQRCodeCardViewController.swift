//
//  QRCodeCardViewController.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/9.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
class WBQRCodeCardViewController: UIViewController {

    // MARK: - 懒加载
    fileprivate lazy var iconView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置标题
        navigationItem.title = "我的名片"
        
        // 2.添加图片容器
        view.addSubview(iconView)
        
        // 3.布局图片容器
        iconView.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        iconView.center = view.center
//        iconView.backgroundColor = UIColor.redColor()
        
        // 4.生成二维码
        let qrcodeImage = creatQRCodeImage()
        
        // 5.将生成好的二维码添加到图片容器上
        iconView.image = qrcodeImage
    }
    
    fileprivate func creatQRCodeImage() -> UIImage{
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜的默认属性
        filter?.setDefaults()
        
        // 3.设置需要生成二维码的数据
        filter?.setValue("安人多梦".data(using: String.Encoding.utf8), forKey: "inputMessage")
        
        // 4.从滤镜中取出生成好的图片
        let ciImage = filter?.outputImage
        
        // 创建高清二维码
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 300)
        
        // 5.创建一个头像
        let icon = UIImage(named: "avatar_vip")
        
        // 6.合成图片(将二维码和头像进行合并)
        let newImage = creteImage(bgImage, iconImage: icon!)
        
        // 7.返回生成好的二维码
        return newImage
    }
    
    /**
    合成图片
    
    :param: bgImage   背景图片
    :param: iconImage 头像
    */
    fileprivate func creteImage(_ bgImage: UIImage, iconImage: UIImage) -> UIImage
    {
        
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景图片
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: bgImage.size))
        // 3.绘制头像
        let W : CGFloat = 50
        let H : CGFloat = W
        let X = (bgImage.size.width - W) * 0.5
        let Y = (bgImage.size.height - H) * 0.5
        iconImage.draw(in: CGRect(x: X, y: Y, width: W, height: H))
        // 4.取出绘制号的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回合成号的图片
        return newImage!
    }
    
    /**
    根据CIImage生成指定大小的高清UIImage
    
    :param: image 指定CIImage
    :param: size    指定大小
    :returns: 生成好的图片
    */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
    

}
