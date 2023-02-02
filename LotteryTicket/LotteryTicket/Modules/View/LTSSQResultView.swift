//
//  LTSSQResultView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/1.
//

import UIKit

class LTSSQResultView: UIView {

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
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.init(hexStr: "#B7DCFF").withAlphaComponent(0.4)
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        self.addSubview(rLabel1)
        rLabel1.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.addSubview(rLabel2)
        rLabel2.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(rLabel1.snp.trailing).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.addSubview(rLabel3)
        rLabel3.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(rLabel2.snp.trailing).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.addSubview(rLabel4)
        rLabel4.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(rLabel3.snp.trailing).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.addSubview(rLabel5)
        rLabel5.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(rLabel4.snp.trailing).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.addSubview(rLabel6)
        rLabel6.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(rLabel5.snp.trailing).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        self.addSubview(bLabel1)
        bLabel1.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(rLabel6.snp.trailing).offset(20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    //MARK: < PublicMethod >
    
    func refreshUI(withData data: LTResultDataItemModel) {
        let redBallsArray = data.red_ball_list
        let blueBallsArray = data.blue_ball_list
        
        rLabel1.text = (redBallsArray[0] as LTBallItemModel).value_string
        rLabel2.text = (redBallsArray[1] as LTBallItemModel).value_string
        rLabel3.text = (redBallsArray[2] as LTBallItemModel).value_string
        rLabel4.text = (redBallsArray[3] as LTBallItemModel).value_string
        rLabel5.text = (redBallsArray[4] as LTBallItemModel).value_string
        rLabel6.text = (redBallsArray[5] as LTBallItemModel).value_string
        
        bLabel1.text = (blueBallsArray[0] as LTBallItemModel).value_string
    }
    
    //MARK: < LazyLoad >
    
    lazy var rLabel1: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FF665C")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
    
    lazy var rLabel2: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FF665C")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
    
    lazy var rLabel3: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FF665C")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
    
    lazy var rLabel4: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FF665C")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
    
    lazy var rLabel5: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FF665C")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
    
    lazy var rLabel6: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#FF665C")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
    
    lazy var bLabel1: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = UIColor.init(hexStr: "#53B8FF")
        tempLabel.textColor = UIColor.black
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textAlignment = NSTextAlignment.center
        tempLabel.layer.cornerRadius = 15
        tempLabel.layer.masksToBounds = true
        
        return tempLabel
    }()
}
