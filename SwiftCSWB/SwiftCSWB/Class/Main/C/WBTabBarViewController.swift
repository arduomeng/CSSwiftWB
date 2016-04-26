//
//  WBTabBarViewController.swift
//  SwiftCSWB
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class WBTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置图片和字体的颜色统一为橙色
         tabBar.tintColor = UIColor(red: 233.0/255, green: 117.0/255, blue: 0, alpha: 1)
        // 加载JSON文件数据动态创建控制器
        loadJsonFile()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 添加加号按钮
        setUpPlusBtn()
        
    }
    
    private func setUpPlusBtn() {
        let W = UIScreen.mainScreen().bounds.size.width * 0.2
        let H = tabBar.bounds.size.height
        let X = 2 * W
        let Y = CGFloat(0)
        
        let plusBtn = UIButton(frame: CGRect(x: X, y: Y, width: W, height: H))
        plusBtn .setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        plusBtn .setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        tabBar.addSubview(plusBtn)
        
        plusBtn.addTarget(self, action: "plusBtnOnClick", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func plusBtnOnClick()  {
        print("plusBtnOnClick")
    }
    
    func loadJsonFile()  {
        let filePath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        let data = NSData(contentsOfFile: filePath!)
        
        if let jsonData = data{
            // NSJSONReadingOptions.MutableContainers 返回的字典为mutable NSJSONSerialization方法会throw异常
            
            do{
                // try 捕获到异常来到catch try!: 捕获到异常程序奔溃
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                
                for itemDict in dictArr as! [[String : String]] {
                    addChildViewController(itemDict["vcName"]!, title: itemDict["title"]!, image: itemDict["image"]!, selectedImage: itemDict["highlightImage"]!)
                }

            }catch{
                
                // 若json数据加载解析失败，则创建默认控制器
                
                print(error)
                
                // 创建子控制器
                addChildViewController("WBHomeViewController", title: "首页", image: "tabbar_home", selectedImage: "tabbar_home_highlighted")
                addChildViewController("WBMessageViewController", title: "消息", image: "tabbar_message_center", selectedImage: "tabbar_message_center_highlighted")
                addChildViewController("WBNULLViewController", title: "", image: "", selectedImage: "")
                addChildViewController("WBPlaygroundViewController", title: "广场", image: "tabbar_discover", selectedImage: "tabbar_discover_highlighted")
                addChildViewController("WBProfileViewController", title: "个人 ", image: "tabbar_profile", selectedImage: "tabbar_profile_highlighted")
                
            }
            
            
        }
    }
    
    // 动态获取命名空间， 根据字符串创建类 Swift中类名为 命名空间.类名
    private func addChildViewController(childController: String, title: String, image: String, selectedImage: String){
        
        // 0.动态获取命名空间
        let name = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        // 1.根据传入的字符串动态创建控制器
        // 1.1获取类名
        let className : AnyClass = NSClassFromString(name + "." + childController)!
        let classVC = className as! UIViewController.Type
        // 1.2创建控制器
        let childVC = classVC.init()
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: image)
        
        // 取消image蓝色状态
        let temp = UIImage(named: selectedImage)
        childVC.tabBarItem.selectedImage = temp?.imageWithRenderingMode(.AlwaysOriginal);
        
        let nav = WBNavigationController(rootViewController: childVC)
        self.addChildViewController(nav)
    }

}
