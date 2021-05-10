//
//  SDBageValueButton.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/9.
//

import UIKit

class SDBageValueButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        self.addGestureRecognizer(pan)
        self.backgroundColor = .red
        self.setTitle("11", for: .normal)
        self.setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        smallView.layer.cornerRadius = self.layer.cornerRadius
    }
    
    @objc private func pan(pan:UIPanGestureRecognizer) {
        let transPoint = pan.translation(in: self)
        var center = self.center
        center.x += transPoint.x
        center.y += transPoint.y
        self.center = center
        pan.setTranslation(.zero, in: self)
        
        let distance = distanceWithSmallView()
        
//        debugPrint("2圆距离===\(distance)")
        var smallR = self.bounds.size.width  * 0.5
        smallR = smallR -  distance / 10.0
        let scale = smallR / (self.bounds.size.width / 2.0)
        smallView.transform = CGAffineTransform(scaleX: scale, y: scale )
        self.smallView.bounds = CGRect(x: 0, y: 0, width: smallR * 2.0, height: smallR * 2.0)
        self.smallView.layer.cornerRadius = smallR

        debugPrint(scale)
        
        
    }
    
    /// 求大圆到小圆之间的长度
    /// - Parameters:
    ///   - smallView: smallView
    ///   - bigView: self
    /// - Returns: 距离
    private func distanceWithSmallView() -> CGFloat{
        //三角函数 a^2 + b^2 = c^2
        let offsetX = self.center.x - smallView.center.x
        let offsetY = self.center.y - smallView.center.y
        return sqrt(offsetX * offsetX + offsetY * offsetY)
    }
    
    
    private lazy var  smallView: UIView = {
        let smallView = UIView(frame: self.frame)
        smallView.backgroundColor = self.backgroundColor
        //为了不让小圆移动,固定小圆,给小圆添加到父试图上
        self.superview?.insertSubview(smallView, belowSubview: self)
        return smallView
    }()
}
