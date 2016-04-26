//
//  WBQRcodeViewController.swift
//  SwiftCSWB
//
//  Created by LCS on 16/4/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class WBQRcodeViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scanLineView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultLabel: UILabel!
    
    // 会话对象
    lazy var session : AVCaptureSession = AVCaptureSession()
    // 输入对象
    lazy var input : AVCaptureInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let inputDevice = try AVCaptureDeviceInput(device: device)
            return inputDevice
        }catch{
            print(error)
            return nil
        }
    }()
    // 输出对象
    lazy var output : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 预览图层
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.session)
        preview.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        return preview
    }()
    
    // 用于添加二维码定位边线的图层
    private lazy var drawLayer : CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Done, target: self, action: "closeVC")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: "save")
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()

        tabBar.selectedItem = tabBar.items![0]

        tabBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1. 开始扫描动画
        startAnimation()
        // 2. 开始扫描二维码
        startScan()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func closeVC(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save(){
        
    }

    func startAnimation(){
        topConstraint.constant = -containerViewHeight.constant
        self.scanLineView.layoutIfNeeded()
        // 执行动画
        UIView.animateWithDuration(2.0) { () -> Void in
            
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.topConstraint.constant = self.containerViewHeight.constant
            
            // 如果动画是通过约束实现的则需要加上layoutIfNeeded
            self.scanLineView.layoutIfNeeded()
        }
    }
    
    func startScan(){
        // 2.1 判断是否能够将输入添加到会话中
        if (!session.canAddInput(input)){
            return
        }
        // 2.2 判断是否能够将输出添加到会话中
        if (!session.canAddOutput(output)){
            return
        }
        // 2.3 将输入输出添加到会话
        session.addInput(input)
        session.addOutput(output)
        // 2.4 设置输出能够解析的数据类型(iOS系统所支持的所有类型)  可支持类型在AVMetadataObject.h
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 2.5 设置可扫描区域(需要自己研究一下，默认0,0,1,1)
        output.rectOfInterest = CGRectMake(0, 0, 1, 1)
        // 2.6 设置输出对象的代理， 只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        // 2.7 设置预览图层
        mainView.layer.insertSublayer(previewLayer, atIndex: 0)
        // 2.8 告诉session开始扫描
        session.startRunning()
    }
    @IBAction func QRcodeCardOnClick(sender: AnyObject) {
        let QRcodeCardVC = WBQRCodeCardViewController()
        navigationController?.pushViewController(QRcodeCardVC, animated: true)
    }
}

extension WBQRcodeViewController : UITabBarDelegate{
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1{
            containerViewHeight.constant = 300
            
        }else{
            containerViewHeight.constant = 150
        }
        
        // 停止动画
        self.scanLineView.layer.removeAllAnimations()
        
        // 重新开始动画
        startAnimation()
    }
}

extension WBQRcodeViewController : AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        // 0.清空drawLayer上的shapeLayer
        clearCorners()
        
        // 1.获取扫描到的数据
        resultLabel.text = metadataObjects.last?.stringValue
        
        // 2.获取二维码位置
        // 2.1 转换坐标
        for object in metadataObjects{
            // 2.1.1 判断数据是否是机器可识别类型
            if object is AVMetadataMachineReadableCodeObject{
                // 2.1.2 将坐标转换成界面可识别坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                
                // 2.1.3绘制图形
                drawCorners(codeObject)
            }
        }
    }
    // (根据corner中的4个点绘制图形)绘制图形
    func drawCorners(codeObject : AVMetadataMachineReadableCodeObject){
        if codeObject.corners.isEmpty{
            return
        }
        
        // 1. 创建绘图图层
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        // 2. 创建路径
        let path = UIBezierPath()
        
        var point = CGPointZero
        var index : Int = 0
        // 从corners数组中取出第一个点，将字典中的X／Y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        // 移动到其它点
        while index < codeObject.corners.count{
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        
        // 关闭路径
        path.closePath()
        
        // 绘制路径
        shapeLayer.path = path.CGPath
        
        // 3. 将图层添加到drawLayer图层
        drawLayer.addSublayer(shapeLayer)
    }
    
    func clearCorners(){
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        
        for subLayer in drawLayer.sublayers!{
            subLayer.removeFromSuperlayer()
        }
    }
}


