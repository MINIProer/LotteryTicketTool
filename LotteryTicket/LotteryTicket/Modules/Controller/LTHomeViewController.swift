//
//  LTHomeViewController.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/28.
//

import UIKit

class LTHomeViewController: UIViewController {

    //MARK: <LifetCycle>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configDefault()
    }
 
    //MARK: <PrivateMethod>
    
    //MARK: 默认配置
    func configDefault() {
        view.backgroundColor = UIColor.white;
    }
}
