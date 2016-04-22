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
        window?.rootViewController = WBTabBarViewController()
        window?.makeKeyAndVisible()
        
        return true;
    }

    func setUpNavTabBar (){
        
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

