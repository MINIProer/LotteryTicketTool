//
//  LTFolderItemCell.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/7.
//

import UIKit

typealias LTHelpClickClourse = (String) -> Void
typealias LTCellClickClourse = () -> Void

class LTFolderItemCell: UICollectionViewCell {
    
    /// 记录类型
    var recordType: LTRecordType = LTRecordType.LTRecordType_SSQ {
        didSet {
            updateUIStatus(withType: recordType)
        }
    }
    
    /// 抽屉栏Item数据模型
    var itemModel: LTFolderItemModel?
    
    /// cell点击回调
    var cellClickClourse: LTCellClickClourse?
    
    /// 帮助按钮点击回调
    var helpClickClourse: LTHelpClickClourse?
    
    //MARK: < Init >

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configDefault()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: < PublicMethod >
    
    //MARK: 执行动画
    func doAnimation() {
        let height = 3.0
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let currentTy = helpImageView.transform.ty
        animation.duration = 1
        animation.values = [currentTy, currentTy - CGFloat(height / 4), currentTy - CGFloat(height / 4 * 2), currentTy - CGFloat(height / 4 * 3), currentTy - height, currentTy - height / 4 * 3, currentTy - height / 4 * 2, currentTy - height / 4, currentTy]
        animation.keyTimes = [0, 0.025, 0.085, 0.2, 0.5, 0.8, 0.915, 0.975, 1]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = HUGE
        helpImageView.layer.add(animation, forKey: "kViewShakerAnimationKey")
    }
    
    //MARK: 移除动画
    func removeAnimation() {
        helpImageView.layer.removeAnimation(forKey: "kViewShakerAnimationKey")
    }
    
    //MARK: 刷新数据
    func refreshUI(withModel model: LTFolderItemModel) {
        self.itemModel = model
        itemLabel.text = model.realShowTitle
    }
    
    //MARK: < PrivateMethod >
    
    //MARK: 默认配置
    func configDefault() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(cellTapAction))
        self.addGestureRecognizer(tapGes)
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.contentView.addSubview(itemLabel)
        itemLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.contentView).inset(UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 5))
        }
        
        self.contentView.addSubview(helpImageView)
        helpImageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView).offset(-10)
            make.centerX.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        self.contentView.addSubview(helpTopView)
        helpTopView.snp.makeConstraints { make in
            make.top.equalTo(self.helpImageView)
            make.leading.bottom.trailing.equalTo(self.contentView)
        }
    }
    
    //MARK: 根据记录类型更新UI状态
    func updateUIStatus(withType recordType: LTRecordType) {
        self.backgroundColor = recordType == LTRecordType.LTRecordType_SSQ ? UIColor.init(hexStr: "#B7DCFF").withAlphaComponent(0.4) : UIColor.init(hexStr: "#FFA4F6").withAlphaComponent(0.4)
    }
    
    //MARK: cell的点击
    @objc func cellTapAction() {
        if cellClickClourse != nil {
            cellClickClourse!()
        }
    }
    
    //MARK: 帮助图片点击事件
    @objc func helpImageViewTapAction() {
        if helpClickClourse != nil {
            helpClickClourse!(self.itemModel!.realShowDesc)
        }
    }
    
    //MARK: < LazyLoad >
    
    /// 公式名称文案
    lazy var itemLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.numberOfLines = 0
        tempLabel.isUserInteractionEnabled = true
        
        return tempLabel
    }()
    
    /// 帮助图片
    lazy var helpImageView: UIImageView = {
        let tempImageView = UIImageView(image: UIImage(named: "lt_help_icon"))
        
        return tempImageView
    }()
    
    /// 帮助图片顶层交互视图
    lazy var helpTopView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.clear
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(helpImageViewTapAction))
        tempView.addGestureRecognizer(tapGes)
        
        return tempView
    }()
}
