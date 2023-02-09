//
//  LTHomeNavBarView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/29.
//

import UIKit

enum LTRecordType: Int, Codable {
    case LTRecordType_SSQ = 0
    case LTRecordType_DLT = 1
}

protocol LTHomeNavBarViewDelegate {
    
    //MARK: 选中导航栏页签
    func didSelectSegment(atIndex index: Int)
}

class LTHomeNavBarView: UIView {
    
    /// 代理对象
    var delegate: LTHomeNavBarViewDelegate?
    
    //MARK: < Init >
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configDefault()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 默认配置
    func configDefault() {
        self.backgroundColor = UIColor.init(hexStr: "#B7DCFF")
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.addSubview(self.segmentView)
        self.segmentView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(44)
        }
    }
    
    //MARK: 更新导航栏状态
    func updateNavBarStatus(withIndex index: Int) {
        switch index {
        case 0:
            UIView.animate(withDuration: CMConst.commonAniDuration) {
                self.backgroundColor = UIColor.init(hexStr: "#B7DCFF")
            }
        case 1:
            UIView.animate(withDuration: CMConst.commonAniDuration) {
                self.backgroundColor = UIColor.init(hexStr: "#FFA4F6")
            }
        default:
            break
        }
    }
    
    //MARK: < lazyLoad >
    
    /// 首页导航栏分页组件
    lazy var segmentView: LTHomeNavBarSegmentView = {
        
        let tempView = LTHomeNavBarSegmentView(frame: CGRectZero)
        
        tempView.clickClourse = { (index: Int) in
            self.updateNavBarStatus(withIndex: index)
            self.delegate?.didSelectSegment(atIndex: index)
        }
        
        return tempView
    }()
}

typealias LTSegmentClickClourse = (Int) -> Void

class LTHomeNavBarSegmentView: UIView {
    
    /// 页签的宽度
    let labelWidth = UIScreen.main.bounds.width / 2
    
    /// 页签点击回调
    var clickClourse: LTSegmentClickClourse?
    
    /// 选中的segment索引
    var selectIndex: Int = 0 {
        didSet {
            updateSegmentStatus(withIndex: selectIndex)
        }
    }

    //MARK: < Init >
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 渲染UI
    func setupUI() {

        self.addSubview(self.ssqLabel)
        self.ssqLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(self)
            make.width.equalTo(Float(labelWidth))
        }
        
        self.addSubview(self.dltLabel)
        self.dltLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(self)
            make.width.equalTo(Float(labelWidth))
        }
        
        self.insertSubview(self.slideView, belowSubview: self.ssqLabel)
        self.slideView.snp.makeConstraints { make in
            make.center.equalTo(self.ssqLabel)
            make.size.equalTo(CGSize(width: Double(labelWidth - 20), height: 30))
        }
    }
    
    //MARK: 更新Segment选中状态
    func updateSegmentStatus(withIndex index: Int) {
        switch index {
        case 0:
            
            self.ssqLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            self.dltLabel.font = UIFont.systemFont(ofSize: 14)
            
            UIView.animate(withDuration: CMConst.commonAniDuration) {
                self.slideView.snp.remakeConstraints { make in
                    make.center.equalTo(self.ssqLabel)
                    make.size.equalTo(CGSize(width: Double(self.labelWidth - 20), height: 30))
                }
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        case 1:
            
            self.ssqLabel.font = UIFont.systemFont(ofSize: 14)
            self.dltLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            
            UIView.animate(withDuration: CMConst.commonAniDuration) {
                self.slideView.snp.remakeConstraints { make in
                    make.center.equalTo(self.dltLabel)
                    make.size.equalTo(CGSize(width: Double(self.labelWidth - 20), height: 30))
                }
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        default:
            break
        }
    }
    
    //MARK: 分页Item点击事件
    @objc func segmentItemClick(gesture: UIGestureRecognizer) {
        
        if let tempLabel = gesture.view as? UILabel {
            
            let tagIndex = tempLabel.tag % 100 - 1
            
            guard self.selectIndex != tagIndex else {
                return
            }
            
            self.selectIndex = tagIndex
            
            if clickClourse != nil {
                clickClourse!(self.selectIndex)
            }
        }
    }
    
    //MARK: < lazyLoad >
    
    /// 分页滑块
    lazy var slideView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.white
        tempView.layer.cornerRadius = 10
        tempView.layer.masksToBounds = true
        
        return tempView
    }()
    
    /// 双色球页签文案
    lazy var ssqLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.tag = 101
        tempLabel.text = "双色球历史记录"
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.isUserInteractionEnabled = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(segmentItemClick))
        tempLabel.addGestureRecognizer(tapGes)
        
        return tempLabel
    }()
    
    /// 大乐透页签文案
    lazy var dltLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.tag = 102
        tempLabel.text = "大乐透历史记录"
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.isUserInteractionEnabled = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(segmentItemClick))
        tempLabel.addGestureRecognizer(tapGes)
        
        return tempLabel
    }()
}
