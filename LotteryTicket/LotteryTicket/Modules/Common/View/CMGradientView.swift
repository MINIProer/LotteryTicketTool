//
//  CMGradientView.swift
//  LotteryTicket
//
//  Created by jiangshulun on 2023/1/29.
//

import UIKit

class CMGradientView: UIView {
    
    lazy var gLayer = CAGradientLayer()

    private var colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
    private var locations: [NSNumber] = [0.0, 1.0]
    private var startPoint = CGPointMake(0.0, 0.0)
    private var endPoint = CGPointMake(1.0, 1.0)
    private var cornerRadius = 0.0
    
    init(colors: Array<CGColor>, locations: Array<NSNumber>, startPoint: CGPoint, endPoint: CGPoint, cornerRadius: CGFloat) {
        self.colors = colors
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerRadius = cornerRadius

        super.init(frame: CGRectZero)

        configUI(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint, cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        gLayer.frame = self.bounds
        
        CATransaction.commit()
    }
    
    func configUI(colors: Array<CGColor>, locations: Array<NSNumber>, startPoint: CGPoint, endPoint: CGPoint, cornerRadius: CGFloat) {
        gLayer.colors = colors;
        gLayer.startPoint = startPoint;
        gLayer.endPoint = endPoint;
        gLayer.locations = locations;
        if cornerRadius >= 0 {
            gLayer.cornerRadius = cornerRadius;
        }
        gLayer.frame = CGRectZero;
        self.layer.addSublayer(self.gLayer)
    }
}
