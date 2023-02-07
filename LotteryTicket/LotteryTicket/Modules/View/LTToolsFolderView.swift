//
//  LTToolsFolderView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/2/3.
//

import UIKit

class LTToolsFolderView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    /// 父控件
    let fatherView: UIView?
    
    /// 工具抽屉栏高度
    static let folderViewH = 154
    
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
            self.containerView.transform = CGAffineTransformMakeTranslation(0, -CGFloat(LTToolsFolderView.folderViewH))
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
    
    //MARK: < PrivateMethod >
    
    //MARK: 默认配置
    func configDefault() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(folderViewTapAction))
        self.addGestureRecognizer(tap)
    }
    
    //MARK: 渲染UI
    func setupUI() {
        
        fatherView!.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalTo(self.fatherView!)
        }
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(LTToolsFolderView.folderViewH)
        }
        
        self.containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.containerView)
            make.trailing.equalTo(self.containerView)
            make.top.equalTo(self.containerView).offset(20);
            make.height.equalTo(100);
        }
    }
    
    //MARK: 抽屉空白点击事件
    @objc func folderViewTapAction() {
        self.hideActionView()
    }
    
    //MARK: < UICollectionViewDataSource & UICollectionViewDelegate >
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "123", for: indexPath)
        cell.backgroundColor = UIColor.cyan
        
        return cell
    }
    
    //MARK: < LazyLoad >
    
    /// 容器视图
    lazy var containerView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.white
        
        let maskPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: Int(CMConst.ScreenWidth), height: LTToolsFolderView.folderViewH), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath;
        tempView.layer.mask = maskLayer;

        return tempView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 75, height: 100)
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: CMConst.ScreenWidth, height: 100), collectionViewLayout: layout)
        tempCollectionView.backgroundColor = UIColor.white
        tempCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tempCollectionView.delegate = self;
        tempCollectionView.dataSource = self;
        tempCollectionView.collectionViewLayout = layout;
        tempCollectionView.showsHorizontalScrollIndicator = false;
        
        tempCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "123")
        
        return tempCollectionView
    }()
}
