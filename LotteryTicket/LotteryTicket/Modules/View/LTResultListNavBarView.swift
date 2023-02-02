//
//  LTResultListNavBarView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/2.
//

import UIKit

protocol LTResultListNavBarViewDelegate {
    
    //MARK: 导航栏返回按钮点击
    func navBarBackButtonClick()
}

class LTResultListNavBarView: UIView {
    
    var type: LTRecordType = LTRecordType.LTRecordType_SSQ {
        didSet {
            self.backgroundColor = type == LTRecordType.LTRecordType_SSQ ? UIColor.init(hexStr: "B7DCFF") : UIColor.init(hexStr: "FFA4F6")
        }
    }
    
    /// 代理对象
    var delegate: LTResultListNavBarViewDelegate?
    
    /// 导航栏标题
    var titleString: String = "" {
        didSet {
            self.titleLabel.text = titleString
        }
    }

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
        self.backgroundColor = UIColor.init(hexStr: "B7DCFF")
    }

    //MARK: 渲染UI
    func setupUI() {
    
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self).inset(UIEdgeInsets(top: 0, left: 15, bottom: 8, right: 0))
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.backButton)
        }
        
        self.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-15)
            make.centerY.equalTo(self.backButton)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
    
    //MARK:
    @objc func backButtonTapAction() {
        self.delegate?.navBarBackButtonClick()
    }
    
    //MARK: < LazyLoad >
    
    lazy var backButton: UIImageView = {
        let tempButton = UIImageView(image: UIImage(named: "topbar_back_icn"))
        tempButton.isUserInteractionEnabled = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(backButtonTapAction))
        tempButton.addGestureRecognizer(tapGes)
        
        return tempButton
    }()
    
    lazy var titleLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        tempLabel.textAlignment = NSTextAlignment.center
        
        return tempLabel
    }()
    
    lazy var moreButton: UIImageView = {
        let tempButton = UIImageView(image: UIImage(named: "lm_legion_member_cell_more_icon"))
        tempButton.isUserInteractionEnabled = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(backButtonTapAction))
        tempButton.addGestureRecognizer(tapGes)
        
        return tempButton
    }()
}
