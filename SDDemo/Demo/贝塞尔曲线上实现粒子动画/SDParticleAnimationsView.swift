//
//  SDParticleAnimationsView.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/25.
//

import UIKit

class SDParticleAnimationsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        self.addGestureRecognizer(pan)
        
        let replicatorLayer = self.layer as! CAReplicatorLayer
        replicatorLayer.instanceCount = 30
        replicatorLayer.instanceDelay  = 0.5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }
    
    @objc private func panGesture(pan:UIPanGestureRecognizer) {
        let curP =  pan.location(in: self)
        if pan.state == .began {
            path.move(to: curP)
        }else if pan.state == .changed {
            path.addLine(to: curP)
            self.setNeedsDisplay()
        }else if pan.state == .ended {
            //添加粒子动画效果
            let frameAnimation = CAKeyframeAnimation(keyPath: "position")
            frameAnimation.path = self.path.cgPath
            frameAnimation.repeatCount = MAXFLOAT
            frameAnimation.duration = 5
            dotLayer.add(frameAnimation, forKey: nil)
        }
    }
    
    override func draw(_ rect: CGRect) {
        path.stroke()
    }
    

    private lazy var path:UIBezierPath = {
       let path = UIBezierPath()
        return path
    }()
    
    private lazy var dotLayer:CALayer = {
        let dotLayer = CALayer()
        dotLayer.frame = CGRect(x: 0, y: 88, width: 10, height: 10)
        dotLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(dotLayer)
        return dotLayer
    }()
}
