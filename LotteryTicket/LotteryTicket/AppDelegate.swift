//
//  AppDelegate.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configRootViewController()
        
        return true
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 配置窗口根控制器
    func configRootViewController() {
        let navVC = UINavigationController(rootViewController: LTMainViewController())
        navVC.isNavigationBarHidden = true
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
}

