//
//  LTCreateTabView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/28.
//

import UIKit

protocol LTHomeBottomTabViewDelegate {
    
    //MARK: 展示结果列表页面
    func showRecordListPage(withType type: LTRecordType)
}

class LTHomeBottomTabView: UIView {
    
    /// 底部TabView的高度
    static let viewH = 64
    
    /// 底部TabView的宽度
    static let viewW = UIScreen.main.bounds.width - 10
    
    /// 代理对象
    var delegate: LTHomeBottomTabViewDelegate?
    
    /// 记录类型
    var recordType: LTRecordType = LTRecordType.LTRecordType_SSQ {
        didSet {
            resetSubTypeViewPositionStatus()
        }
    }
    
    /// 是否展示了子类型视图
    private var hasShown: Bool = false
    
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
        self.backgroundColor = UIColor.clear
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.addSubview(showView)
        showView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 70, height: LTHomeBottomTabView.viewH - 12))
        }
        
        self.addSubview(playSSQLabel)
        playSSQLabel.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: Int(LTHomeBottomTabView.viewW) - 75, height: LTHomeBottomTabView.viewH - 12))
        }
        
        self.addSubview(playDLTLabel)
        playDLTLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: Int(LTHomeBottomTabView.viewW) - 75, height: LTHomeBottomTabView.viewH - 12))
        }
    }
    
    //MARK: 重置子类型视图位置状态
    func resetSubTypeViewPositionStatus() {
        
        self.showView.gLayer.colors = [UIColor.init(hexStr: "#B7DCFF").cgColor, UIColor.init(hexStr: "#FFA4F6").cgColor];
        
        guard self.hasShown else {
            return
        }
        
        UIView.animate(withDuration: CMConst.commonAniDuration) {
            self.showView.snp.remakeConstraints { make in
                make.center.equalTo(self)
                make.size.equalTo(CGSize(width: 70, height: LTHomeBottomTabView.viewH - 12))
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        self.showView.resetStatus()
        
        subTypeViewHideAnimation(withType: self.recordType)
        
        self.hasShown = false
    }
    
    //MARK: 展示子类型视图
    @objc func showViewTapAction() {
        
        guard self.hasShown else {
            self.showView.updateStatus(withType: self.recordType)
            showSubTypeView(withType: self.recordType)
            self.hasShown = !self.hasShown
            
            return
        }
        
        resetSubTypeViewPositionStatus()
    }
    
    //MARK: 展示子类型玩法视图
    func showSubTypeView(withType type: LTRecordType) {
        
        UIView.animate(withDuration: CMConst.commonAniDuration, animations: {
            self.showView.snp.remakeConstraints { make in
                if type == LTRecordType.LTRecordType_SSQ {
                    make.trailing.equalTo(self)
                } else {
                    make.leading.equalTo(self)
                }
                make.centerY.equalTo(self)
                make.size.equalTo(CGSize(width: 70, height: LTHomeBottomTabView.viewH - 12))
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { (isFinish) in
            
            if isFinish {
                self.subTypeViewShowAnimation(withType: type)
            }
        }
            
        switch type {
        case .LTRecordType_SSQ:
            self.showView.gLayer.colors = [UIColor.init(hexStr: "#B7DCFF").cgColor, UIColor.init(hexStr: "#B7DCFF").cgColor]
        case .LTRecordType_DLT:
            self.showView.gLayer.colors = [UIColor.init(hexStr: "#FFA4F6").cgColor, UIColor.init(hexStr: "#FFA4F6").cgColor]
            fallthrough
        default:
            break
        }
    }
    
    //MARK: 子类型玩法视图展示&动画
    func subTypeViewShowAnimation(withType type: LTRecordType) {
        if type == LTRecordType.LTRecordType_SSQ {
            UIView.animate(withDuration: CMConst.commonAniDuration) {
                self.playSSQLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: CMConst.commonAniDuration) {
                self.playDLTLabel.alpha = 1
            }
        }
    }
    
    //MARK: 子类型玩法视图隐藏&动画
    func subTypeViewHideAnimation(withType type: LTRecordType) {
        UIView.animate(withDuration: CMConst.commonAniDuration) {
            self.playSSQLabel.alpha = 0
        }
        
        UIView.animate(withDuration: CMConst.commonAniDuration) {
            self.playDLTLabel.alpha = 0
        }
    }
    
    //MARK: 子类型玩法视图点击事件
    @objc func subTypeViewTapAction(gesture: UIGestureRecognizer) {
            
        if let tempLabel = gesture.view as? UILabel {
            
            let tagIndex = tempLabel.tag % 100 - 1
            
            let recordType = LTRecordType(rawValue: tagIndex)
            
            self.delegate?.showRecordListPage(withType: recordType!)
        }
    }
    
    //MARK: < LazyLoad >
    
    /// 展示子类型视图的视图
    lazy var showView: LTShowSubTypeView = {
        var tempShowSubTypeView = LTShowSubTypeView(colors: [UIColor.init(hexStr: "#B7DCFF").cgColor, UIColor.init(hexStr: "#FFA4F6").cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1), cornerRadius: 0)
    
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(self.showViewTapAction));
        tempShowSubTypeView.addGestureRecognizer(tapGes)

        return tempShowSubTypeView
    }()
    
    /// 双色球 - Play按钮
    lazy var playSSQLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#B7DCFF")
        tempLabel.tag = 101
        tempLabel.text = "生成双色球"
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.isUserInteractionEnabled = true
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        tempLabel.alpha = 0;
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(self.subTypeViewTapAction));
        tempLabel.addGestureRecognizer(tapGes)
        
        return tempLabel
    }()
    
    /// 大乐透 - Play按钮
    lazy var playDLTLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FFA4F6")
        tempLabel.tag = 102
        tempLabel.text = "生成大乐透"
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.isUserInteractionEnabled = true
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        tempLabel.alpha = 0;
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(self.subTypeViewTapAction));
        tempLabel.addGestureRecognizer(tapGes)
        
        return tempLabel
    }()
}

class LTShowSubTypeView: CMGradientView {
    
    //MARK: < Init >
    
    override init(colors: Array<CGColor>, locations: Array<NSNumber>, startPoint: CGPoint, endPoint: CGPoint, cornerRadius: CGFloat) {
        super.init(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint, cornerRadius: cornerRadius)
        
        configDefault()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < PublicMethod >

    //MARK: 更新状态
    func updateStatus(withType type: LTRecordType) {
        UIView.animate(withDuration: CMConst.commonAniDuration) {
            if type == LTRecordType.LTRecordType_SSQ {
                self.topLineView.transform = CGAffineTransform(rotationAngle: -((15 * .pi) / 180))
                self.bottomLineView.transform = CGAffineTransform(rotationAngle: ((15 * .pi) / 180))
            } else {
                self.topLineView.transform = CGAffineTransform(rotationAngle: ((15 * .pi) / 180))
                self.bottomLineView.transform = CGAffineTransform(rotationAngle: -((15 * .pi) / 180))
            }
        }
    }
    
    //MARK: 重置状态
    func resetStatus() {
        UIView.animate(withDuration: CMConst.commonAniDuration) {
            self.topLineView.transform = CGAffineTransformIdentity
            self.bottomLineView.transform = CGAffineTransformIdentity
        }
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 默认配置
    func configDefault() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.addSubview(self.topLineView)
        self.topLineView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(5)
            make.bottom.equalTo(self.snp.centerY).offset(-5)
        }
        
        self.addSubview(self.bottomLineView)
        self.bottomLineView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(5)
            make.top.equalTo(self.snp.centerY).offset(5)
        }
    }
    
    //MARK: < LazyLoad >
    
    /// 顶部线
    lazy var topLineView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.white
        tempView.layer.cornerRadius = 2.5
        tempView.layer.masksToBounds = true
        
        return tempView
    }()
    
    /// 底部线
    lazy var bottomLineView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.white
        tempView.layer.cornerRadius = 2.5
        tempView.layer.masksToBounds = true
        
        return tempView
    }()
}
