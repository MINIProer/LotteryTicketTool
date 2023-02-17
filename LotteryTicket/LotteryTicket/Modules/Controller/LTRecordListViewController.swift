//
//  LTRecordListViewController.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/15.
//

import UIKit

class LTRecordListViewController: UIViewController, UITableViewDataSource {

    /// 记录类型
    var recordType: LTRecordType
    
    var dataSourceArrayM = [LTResultDataItemModel]()
    
    //MARK: < Init >
    
    init(recordType: LTRecordType) {
        self.recordType = recordType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < LifeCycle >
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: < PublicMethod >
    
    //MARK: 加载数据
    func loadData() {
        DispatchQueue.global(qos: .default).async {
            if let dataSource = LTDatabaseManager.shared.queryAll(WithType: self.recordType) {
                self.dataSourceArrayM = []
                self.dataSourceArrayM += dataSource
                DispatchQueue.main.async {
                    print("\(self.recordType == LTRecordType.LTRecordType_SSQ ? "双色球：" : "大乐透：")" + "\(dataSource.count)")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    //MARK: < UITablViewDatsource >
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArrayM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LTResultItemCell") as? LTResultItemCell
        if cell == nil {
            cell = LTResultItemCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "LTResultItemCell")
        }
//        cell!.delegate = self
        cell!.recordType = self.recordType
        cell!.refreshUI(withData: self.dataSourceArrayM[indexPath.row])
        
        return cell!
    }
    
    //MARK: < LazyLoad >
    
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
