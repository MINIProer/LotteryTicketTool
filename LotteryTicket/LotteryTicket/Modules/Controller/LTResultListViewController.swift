//
//  LTResultListViewController.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/1.
//

import UIKit

class LTResultListViewController: UIViewController, UITableViewDataSource, LTResultListNavBarViewDelegate, LTResultItemCellDelegate {

    /// 记录类型
    var type: LTRecordType?
    
    /// 数据源
    var dataSourceArrayM = [Any]()
    
    //MARK: < Init >
    
    init(type: LTRecordType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < LifeCycle >
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configDefault()
        setupUI()
        loadData()
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 默认配置
    func configDefault() {
        self.view.backgroundColor = UIColor.white
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.view.addSubview(navBarView)
        navBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.height.equalTo(CMConst.commonNavBarH)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navBarView.snp.bottom)
            make.leading.bottom.trailing.equalTo(self.view)
        }
    }
    
    //MARK: 加载数据
    func loadData() {
        var dataSourceVM = LTDataSourceViewModel()
        dataSourceVM.dataSourceType = LTDataSourceType(rawValue: self.type!.rawValue)
        dataSourceVM.fetchLotteryTicketResult(withTimes: 8) { model in
            self.dataSourceArrayM = []
            self.dataSourceArrayM += model.data
            self.tableView.reloadData()
        }
    }
    
    //MARK: < UITablViewDatsource >
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArrayM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LTResultItemCell") as? LTResultItemCell
        cell?.delegate = self
        cell?.recordType = self.type!
        cell?.refreshUI(withData: self.dataSourceArrayM[indexPath.row] as! LTResultDataItemModel)
        
        return cell!
    }
    
    //MARK: < LTResultListNavBarViewDelegate >
    
    func navBarBackButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: < LTResultItemCellDelegate >
    
    func copyClick(number: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = number
    }
    
    //MARK: < LazyLoad >
    
    /// 导航栏
    lazy var navBarView: LTResultListNavBarView = {
        let tempView = LTResultListNavBarView()
        tempView.delegate = self
        tempView.type = self.type!
        tempView.titleString = self.type == LTRecordType.LTRecordType_SSQ ? "双色球列表" : "大乐透列表"
        
        return tempView
    }()
    
    /// 列表视图
    lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        tempTableView.dataSource = self
        tempTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tempTableView.rowHeight = CGFloat(CMConst.commonResultListItemHeight)
        
        tempTableView.register(LTResultItemCell.self, forCellReuseIdentifier: "LTResultItemCell")
        
        return tempTableView
    }()
}
