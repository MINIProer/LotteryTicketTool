//
//  LTResultItemCell.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/2.
//

import UIKit

protocol LTResultItemCellDelegate: NSObjectProtocol {
    
    //MARK: 复制按钮点击
    func copyClick(number: String)
}

class LTResultItemCell: UITableViewCell {

    /// 代理对象
    weak var delegate: LTResultItemCellDelegate?
    
    /// 记录类型
    var recordType: LTRecordType = LTRecordType.LTRecordType_SSQ {
        didSet {
            setupUI(withType: recordType)
        }
    }

    //MARK: < Init >
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 默认配置
    func configDefault() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    //MARK: 渲染UI
    func setupUI(withType type: LTRecordType) {
        
        if type == LTRecordType.LTRecordType_SSQ {
            
            self.contentView.addSubview(ssqResultView)
            ssqResultView.snp.makeConstraints { make in
                make.centerY.equalTo(self.contentView)
                make.leading.equalTo(self.contentView).offset(10)
                make.width.equalTo(CMConst.commonResultViewWidth)
                make.height.equalTo(CMConst.commonResultViewHeight)
            }
            
        } else {
            
            self.contentView.addSubview(dltResultView)
            dltResultView.snp.makeConstraints { make in
                make.centerY.equalTo(self.contentView)
                make.leading.equalTo(self.contentView).offset(10)
                make.width.equalTo(CMConst.commonResultViewWidth)
                make.height.equalTo(CMConst.commonResultViewHeight)
            }
        }
    }
    
    //MARK: < PublicMethod >
    
    func refreshUI(withData data: LTResultDataItemModel) {
        if self.recordType == LTRecordType.LTRecordType_SSQ {
            ssqResultView.refreshUI(withData: data)
        } else {
            dltResultView.refreshUI(withData: data)
        }
    }
    
    //MARK: < LazyLoad >
    
    lazy var ssqResultView: LTSSQResultView = {
        let tempView = LTSSQResultView()
        tempView.copyClickClourse = { value in
            self.delegate?.copyClick(number: value)
        }
        
        return tempView
    }()
    
    lazy var dltResultView: LTDLTResultView = {
        let tempView = LTDLTResultView()
        tempView.copyClickClourse = { value in
            self.delegate?.copyClick(number: value)
        }
        
        return tempView
    }()
}
