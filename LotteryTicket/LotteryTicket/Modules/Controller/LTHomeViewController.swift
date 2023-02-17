//
//  LTHomeViewController.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/28.
//

import UIKit

class LTHomeViewController: UIViewController, LTHomeNavBarViewDelegate, LTHomeBottomTabViewDelegate, UIScrollViewDelegate {

    /// 记录类型
    var recordType = LTRecordType.LTRecordType_SSQ
    
    var ssqChildVc: LTRecordListViewController?
    var dltChildVc: LTRecordListViewController?

    //MARK: <LifetCycle>
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configDefault()
        setupUI()
        configChildVCs()
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
        
        self.view.addSubview(self.bodyScrollView)
    }
    
    //MARK: 配置子控制器
    func configChildVCs() {
        ssqChildVc = LTRecordListViewController(recordType: LTRecordType.LTRecordType_SSQ)
        addChild(ssqChildVc!)
        bodyScrollView.addSubview(ssqChildVc!.view)
        ssqChildVc!.view.frame = CGRectMake(0, 0, CMConst.ScreenWidth, CMConst.ChildVcHeight)
        ssqChildVc!.didMove(toParent: self)
        ssqChildVc!.loadData()
        
        dltChildVc = LTRecordListViewController(recordType: LTRecordType.LTRecordType_DLT)
        addChild(dltChildVc!)
        bodyScrollView.addSubview(dltChildVc!.view)
        dltChildVc!.view.frame = CGRectMake(CMConst.ScreenWidth, 0, CMConst.ScreenWidth, CMConst.ChildVcHeight)
        dltChildVc!.didMove(toParent: self)
    }
    
    //MARK: 根据索引加载数据
    func loadData(withIndex index: Int) {
        if index == 0 {
            ssqChildVc!.loadData()
        } else if index == 1 {
            dltChildVc!.loadData()
        }
    }
    
    //MARK: < LTHomeNavBarViewDelegate >
    
    func didSelectSegment(atIndex index: Int) {
        let recordType = LTRecordType(rawValue: index)
        self.homeBottomTabView.recordType = recordType!
        self.recordType = recordType!
        
        self.bodyScrollView.setContentOffset(CGPoint(x: index * Int(CMConst.ScreenWidth), y: 0), animated: true)
        
        loadData(withIndex: index)
    }
    
    //MARK: < LTHomeBottomTabViewDelegate >
    
    func showRecordListPage(withType type: LTRecordType) {
        let resultListVC = LTResultListViewController.init(type: type)
        self.navigationController?.pushViewController(resultListVC, animated: true)
    }
    
    //MARK: < UIScrollViewDelegate >
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScrolling(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrolling(scrollView)
    }

    func scrollViewDidEndScrolling(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / CMConst.ScreenWidth)
        if page == self.homeNavBarView.currentIndex {
            return
        }
        self.homeNavBarView.currentIndex = page
        
        loadData(withIndex: page)
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
    
    lazy var bodyScrollView: UIScrollView = {
        let tempView = UIScrollView(frame: CGRect(x: 0, y: CMConst.commonNavBarH, width: self.view.bounds.size.width, height: CMConst.ChildVcHeight))
        tempView.isPagingEnabled = true
        tempView.contentSize = CGSize(width: CMConst.ScreenWidth * 2, height: 0)
        tempView.delegate = self
        tempView.bounces = false
        
        return tempView
    }()
}

