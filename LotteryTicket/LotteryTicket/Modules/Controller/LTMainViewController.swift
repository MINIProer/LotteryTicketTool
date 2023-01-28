//
//  LTMainViewController.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/28.
//

import UIKit

class LTMainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configChildVC()
    }
    
    //MARK: 配置子控制器
    func configChildVC() {
        let homeVC = LTHomeViewController()
        self.view.addSubview(homeVC.view)
        self.addChild(homeVC)
    }
}
