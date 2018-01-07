//
//  CircleView.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/4.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setView()
    }
    
    private func setView() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width / 2.0, startAngle: 0.0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor(hexString: "#b0ff00")?.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 10.0
        circleLayer.lineCap = "round"
        circleLayer.strokeEnd = 0.0
        
        layer.addSublayer(circleLayer)
        
    }
    
    func animateCircle(to endValue: CGFloat){
        circleLayer.strokeEnd = endValue
    }
    
}
