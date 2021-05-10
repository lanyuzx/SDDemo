//
//  SDBageValueButton.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/9.
//

import UIKit

class SDBageValueButton: UIButton {
    //允许拖动的距离
    private let dragDistance: CGFloat = 60.0
    
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
        
        let distance = distanceWithSmallView(smallView: smallView, bigView: self)
//        debugPrint("2圆距离===\(distance)")
        var smallR = bounds.size.width  * 0.5
        smallR = smallR -  distance / 10.0
        let scale = smallR / (self.bounds.size.width / 2.0)
        smallView.transform = CGAffineTransform(scaleX: scale, y: scale )
        smallView.bounds.size = CGSize(width: smallR * 2, height: smallR * 2)
        smallView.layer.cornerRadius = smallR
        
        if !smallView.isHidden {
            let path = pathWithSmallView(smallView: smallView, bigView: self)
            superview?.layer.insertSublayer(shapeLayer, at: 0)
            shapeLayer.path = path.cgPath
        }
        
        if distance > dragDistance {
            smallView.isHidden = true
            shapeLayer.removeFromSuperlayer()
        }
        if pan.state == .ended {
            if distance < dragDistance {
                center = smallView.center
                smallView.isHidden = false
                shapeLayer.removeFromSuperlayer()
            }else {
                //播放一个小动画
                let imageView = UIImageView(frame: self.bounds)
                let imgs = ["1","2","3"]
                var images = [UIImage]()
                for item in imgs {
                    images.append(UIImage(named: item) ?? UIImage())
                }
                imageView.animationImages = images
                imageView.animationRepeatCount = 1
                imageView.animationDuration = 1
                imageView.startAnimating()
                addSubview(imageView)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.removeFromSuperview()
                }
            }
        }
       
    }
    
    /// 求大圆到小圆之间的长度
    /// - Parameters:
    ///   - smallView: smallView
    ///   - bigView: self
    /// - Returns: 距离
    private func distanceWithSmallView(smallView: UIView , bigView:UIView) -> CGFloat{
        //勾股定理 a^2 + b^2 = c^2
        let offsetX = self.center.x - smallView.center.x
        let offsetY = self.center.y - smallView.center.y
        return sqrt(offsetX * offsetX + offsetY * offsetY)
    }
    
    private func pathWithSmallView(smallView: UIView, bigView:UIView) -> UIBezierPath {
        let x1 = smallView.center.x
        let x2 = bigView.center.x
        let y1 = smallView.center.y
        let y2 = bigView.center.y
        let distance = distanceWithSmallView(smallView: smallView, bigView: bigView)
        
        let cosΘ = (y2 - y1) / distance
        let sinΘ = (x2 - x1) / distance
        let r1 = smallView.bounds.size.width * 0.5
        let r2 = bigView.bounds.size.width * 0.5
        //开始求点
        let pointA = CGPoint(x: x1 - r1 * cosΘ, y: y1 + r1 * sinΘ)
        let pointB = CGPoint(x: x1 + r1 * cosΘ, y: y1 - r1 * sinΘ)
        let pointC = CGPoint(x: x2 + r2 * cosΘ, y: y2 - r2 * sinΘ)
        let pointD = CGPoint(x: x2 - r2 * cosΘ, y: y2 + r2 * sinΘ)
        let pointO = CGPoint(x: pointA.x + distance * 0.5 * sinΘ, y: pointA.y + distance * 0.5 + cosΘ)
        let pointP = CGPoint(x: pointB.x + distance * 0.5 * sinΘ, y: pointB.y + distance * 0.5 + cosΘ)
        //开始描点
        let path = UIBezierPath()
        path.move(to: pointA)
        path.addLine(to: pointB)
        //添加控制点
        path.addQuadCurve(to: pointC, controlPoint: pointP)
        path.addLine(to: pointD)
        //添加控制点
        path.addQuadCurve(to: pointA, controlPoint: pointO)
        return path
    }
    
    private lazy var shapeLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.red.cgColor
        return shapeLayer
    }()
    
    private lazy var  smallView: UIView = {
        let smallView = UIView(frame: self.frame)
        smallView.backgroundColor = self.backgroundColor
        //为了不让小圆移动,固定小圆,给小圆添加到父试图上
        self.superview?.insertSubview(smallView, belowSubview: self)
        return smallView
    }()
}
