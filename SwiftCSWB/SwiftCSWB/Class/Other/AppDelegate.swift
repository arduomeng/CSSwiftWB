//
//  AppDelegate.swift
//  SwiftCSWB
//
//  Created by Apple on 16/4/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = isNewfeature()
        window?.makeKeyAndVisible()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeViewController", name: switchViewController, object: nil)
        
        setUpNavTabBar()
        
        // 打印程序路径
        let path = NSHomeDirectory()
        CSprint(path)
        
        return true;
    }
    
    func changeViewController(){
        window?.rootViewController = WBTabBarViewController()
        print(window?.rootViewController)
        
    }
    
    private func isNewfeature() -> UIViewController{
        
        // as! 强制类型转换，转换失败则发生运行时错误 子类可以强制转换成父类，父类不能强制转换成子类
        let currnetVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        // as? 若转换失败，则返回nil 不会报错 
        // ?? a ?? b 中的 ?? 就是是空值合并运算符，会对 a 进行判断，如果不为 nil 则解包，否则就返回 b
        //    1.a 必须是 optional 的
        //    2.b 必须和 a 类型一致
        let localVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        if currnetVersion.compare(localVersion) == NSComparisonResult.OrderedDescending{
            NSUserDefaults.standardUserDefaults().setObject(currnetVersion, forKey: "CFBundleShortVersionString")
            return WBNewfeatureCollectionViewController()
        }
        return WBTabBarViewController()
        
    }

    func setUpNavTabBar (){
        
        UIBarButtonItem.appearance().tintColor = UIColor.orangeColor()
        
        // TabBarItem
//        var item = UITabBarItem.appearance();
//    
//        var attr = NSMutableDictionary()
//        attr[NSFontAttributeName] = UIFont.systemFontOfSize(14)
//        attr[NSForegroundColorAttributeName] = UIColor.grayColor()
//    
//        var attr2 = NSMutableDictionary();
//        attr2[NSFontAttributeName] = UIFont.systemFontOfSize(14)
//        attr2[NSForegroundColorAttributeName] = UIColor.redColor()
//        
//        item.setTitleTextAttributes(attr as! [String : AnyObject], forState: UIControlState.Normal)
//        item.setTitleTextAttributes(attr2 as! [String : AnyObject], forState: UIControlState.Highlighted)
        
        
        // NavigationBar appearanceWhenContainedIn方法含义，设置BDJNavigationController的通用设置.其他的导航栏不会影响
//        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[BDJNavigationController class], nil];
//        
//        NSMutableDictionary *attrNav = [[NSMutableDictionary alloc] init];
//        attrNav[NSFontAttributeName] = [UIFont systemFontOfSize:20];
//        attrNav[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
//        
//        navBar.titleTextAttributes = attrNav;
//        [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    

}

