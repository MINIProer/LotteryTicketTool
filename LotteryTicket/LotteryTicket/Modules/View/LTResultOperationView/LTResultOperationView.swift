//
//  LTResultOperationView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/10.
//

import UIKit

protocol LTResultOperationViewDelegate: NSObjectProtocol {
    
    //MARK: 复制
    func copyClick(_ model: LTResultDataItemModel?)
    
    //MARK: 复制 & 记录
    func copyRecordClick(_ model: LTResultDataItemModel?)
}

class LTResultOperationView: UIView {

    /// 代理对象
    weak var delegate: LTResultOperationViewDelegate?
    
    /// 父控件
    let fatherView: UIView?
    
    /// 记录类型
    var recordType: LTRecordType?
    
    /// 彩票模型
    var model: LTResultDataItemModel?
    
    //MARK: < Init >
    
    init(fatherView: UIView?) {
        self.fatherView = fatherView
        super.init(frame: CGRectZero)
    
        configDefault()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < PublicMethod >
    
    func showActionView() {
        guard fatherView != nil else {
            return
        }
        
        UIView.animate(withDuration: CMConst.commonAniDuration) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.containerView.transform = CGAffineTransformMakeTranslation(0, 170 + (CMConst.ScreenHeight - 170) / 2)
        }
    }
    
    func hideActionView() {
        guard fatherView != nil else {
            return
        }
        
        UIView.animate(withDuration: CMConst.commonAniDuration, delay: 0, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.containerView.transform = CGAffineTransformIdentity
        }) { (isFinished) in
            if isFinished {
                self.removeFromSuperview()
            }
        }
    }
    
    func createResultView(withType type: LTRecordType, model: LTResultDataItemModel) {
        
        self.recordType = type
        self.model = model
        
        if (type == LTRecordType.LTRecordType_SSQ) {
            
            self.containerView.addSubview(ssqResultView)
            ssqResultView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(self.containerView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
                make.height.equalTo(CMConst.commonResultViewHeight)
            }
            
            ssqResultView.refreshUI(withData: model)
            
            setupOperationUI(withTargetView: ssqResultView)
            
        } else if (type == LTRecordType.LTRecordType_DLT) {
            
            self.containerView.addSubview(dltResultView)
            dltResultView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(self.containerView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
                make.height.equalTo(CMConst.commonResultViewHeight)
            }
            
            dltResultView.refreshUI(withData: model)
            
            setupOperationUI(withTargetView: dltResultView)
        }
    }
    
    //MARK: < PrivateMethod >

    //MARK: 默认配置
    func configDefault() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
    }
    
    //MARK: 渲染UI
    func setupUI() {
        fatherView!.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalTo(self.fatherView!)
        }
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top)
            make.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(170)
        }
    }
    
    //MARK: 渲染操作UI
    func setupOperationUI(withTargetView view: UIView) {
        
        containerView.addSubview(copyBtnLabel)
        copyBtnLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.size.equalTo(CGSize(width: (Int(CMConst.ScreenWidth) - 50) / 2, height: 60))
        }
        
        containerView.addSubview(copyRecordBtnLabel)
        copyRecordBtnLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(10)
            make.trailing.equalTo(view)
            make.size.equalTo(CGSize(width: (Int(CMConst.ScreenWidth) - 50) / 2, height: 60))
        }
    }
    
    //MARK: 拷贝点击事件
    @objc func copyTapAction() {
        self.hideActionView()
        self.delegate?.copyClick(self.model)
    }
    
    //MARK: 拷贝&记录点击事件
    @objc func copyRecordTapAction() {
        self.hideActionView()
        self.delegate?.copyRecordClick(self.model)
    }
    
    //MARK: < LazyLoad >
    
    /// 容器视图
    lazy var containerView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.white
        tempView.layer.cornerRadius = 10
        tempView.layer.masksToBounds = true
        
        return tempView
    }()
    
    /// 双色球结果视图
    lazy var ssqResultView: LTSSQResultView = {
        let tempView = LTSSQResultView()
        tempView.shouldHideCopyButton = true
        
        return tempView
    }()
    
    /// 大乐透结果视图
    lazy var dltResultView: LTDLTResultView = {
        let tempView = LTDLTResultView()
        tempView.shouldHideCopyButton = true
        
        return tempView
    }()
    
    /// 复制按钮
    lazy var copyBtnLabel: UILabel = {
        let tempBtnLabel = UILabel()
        tempBtnLabel.layer.cornerRadius = 10
        tempBtnLabel.layer.masksToBounds = true
        tempBtnLabel.backgroundColor = self.recordType == LTRecordType.LTRecordType_SSQ ? UIColor.init(hexStr: "#B7DCFF").withAlphaComponent(0.4) : UIColor.init(hexStr: "#FFA4F6").withAlphaComponent(0.4)
        tempBtnLabel.text = "拷贝"
        tempBtnLabel.textColor = UIColor.black
        tempBtnLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        tempBtnLabel.textAlignment = NSTextAlignment.center
        tempBtnLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyTapAction))
        tempBtnLabel.addGestureRecognizer(tap)
        
        return tempBtnLabel
    }()
    
    /// 复制并记录按钮
    lazy var copyRecordBtnLabel: UILabel = {
        let tempBtnLabel = UILabel()
        tempBtnLabel.layer.cornerRadius = 10
        tempBtnLabel.layer.masksToBounds = true
        tempBtnLabel.backgroundColor = self.recordType == LTRecordType.LTRecordType_SSQ ? UIColor.init(hexStr: "#B7DCFF").withAlphaComponent(0.4) : UIColor.init(hexStr: "#FFA4F6").withAlphaComponent(0.4)
        tempBtnLabel.text = "拷贝 & 记录"
        tempBtnLabel.textColor = UIColor.black
        tempBtnLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        tempBtnLabel.textAlignment = NSTextAlignment.center
        tempBtnLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyRecordTapAction))
        tempBtnLabel.addGestureRecognizer(tap)
        
        return tempBtnLabel
    }()
}
