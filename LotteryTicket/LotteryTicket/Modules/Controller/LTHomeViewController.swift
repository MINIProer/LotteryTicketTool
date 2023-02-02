//
//  LTHomeViewController.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/28.
//

import UIKit

class LTHomeViewController: UIViewController, LTHomeNavBarViewDelegate, LTHomeBottomTabViewDelegate {

    //MARK: <LifetCycle>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configDefault()
        setupUI()
    }
    
    //MARK: <PrivateMethod>
    
    //MARK: 默认配置
    func configDefault() {
        view.backgroundColor = UIColor.white;
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.view.addSubview(self.homeNavBarView)
        self.homeNavBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.height.equalTo(CMConst.commonNavBarH)
        }
        
        self.view.addSubview(self.homeBottomTabView)
        self.homeBottomTabView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 34, right: 5))
            make.height.equalTo(LTHomeBottomTabView.viewH)
        }
    }
    
    //MARK: < LTHomeNavBarViewDelegate >
    
    func didSelectSegment(atIndex index: Int) {
        let recordType = LTRecordType(rawValue: index)
        self.homeBottomTabView.recordType = recordType!
    }
    
    //MARK: < LTHomeBottomTabViewDelegate >
    
    func showRecordListPage(withType type: LTRecordType) {
        print(type)
        let resultListVC = LTResultListViewController.init(type: type)
        self.navigationController?.pushViewController(resultListVC, animated: true)
    }
    
    //MARK: < LazyLoad >
    
    /// 首页顶部导航栏
    lazy var homeNavBarView: LTHomeNavBarView = {
        let tempHomeNavBarView = LTHomeNavBarView()
        tempHomeNavBarView.delegate = self

        return tempHomeNavBarView
    }()
    
    /// 首页底部Tab视图
    lazy var homeBottomTabView: LTHomeBottomTabView = {
        let tempView = LTHomeBottomTabView()
        tempView.delegate = self
        
        return tempView
    }()
}

