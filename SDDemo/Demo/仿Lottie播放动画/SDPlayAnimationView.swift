//
//  SDPlayAnimationView.swift
//  Test
//
//  Created by lanlan on 2021/4/15.
//
import UIKit

class SDPlayAnimationView: UIView {
    
   private var isPlayAnimation:Bool   {
        get{
           let animation = lineOneLayer.animation(forKey: "animation1")
            guard let _ = animation  else {
                return false
            }
            return true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubUI()
    }
    
    deinit {
        debugPrint(self)
    }
    
    private func layoutSubUI() {
        
        let animationWidth = self.bounds.size.width
        
        let animationHeight = self.bounds.size.height
        
        let itemWidth = animationWidth / 3 * 0.45
        
        lineOneLayer.frame = CGRect(x: 0, y: animationHeight - 10, width: itemWidth, height: 10)
        
        lineTwoLayer.frame = CGRect(x: animationWidth / 2 -  itemWidth / 2, y: self.frame.size.height - 20, width: itemWidth, height: 20)
        
        lineThreeLayer.frame = CGRect(x: animationWidth -  itemWidth , y: self.frame.size.height - 15 , width: itemWidth, height: 15)
        self.layer.sublayers?.forEach({ (item) in
            item.cornerRadius = itemWidth * 0.5
        })
    }
    
    private lazy var lineOneLayer:CALayer = setupAnimationLayer()
    
    private lazy var lineTwoLayer:CALayer = setupAnimationLayer()
    
    private lazy var lineThreeLayer:CALayer = setupAnimationLayer()
}
 

extension SDPlayAnimationView: CAAnimationDelegate{
    
    
    /// 快速创建SDPlayAnimationView
    /// - Returns: SDPlayAnimationView
    public class func playAnimationView() -> SDPlayAnimationView {
        return SDPlayAnimationView()
    }
    
    
    /// 停止动画
    public  func stopAnimation() {
        self.layer.sublayers?.forEach({ (item) in
            item.removeAllAnimations()
        })
    }
    
    
    /// 开始动画
    public func startAnimation() {
        if isPlayAnimation {
            return
        }
        self.layoutIfNeeded()
        let height = self.bounds.size.height
        setupKeyframeAnimation(layer: lineOneLayer, values: [height * 0.2,height * 0.6,height,height * 0.6,height * 0.2],key: "animation1")
        setupKeyframeAnimation(layer: lineTwoLayer, values: [height * 0.6,height,height * 0.6,height * 0.2,height * 0.6],key: "animation2")
        self.setupKeyframeAnimation(layer: self.lineThreeLayer, values: [height,height * 0.6,height * 0.2,height * 0.6,height],key: "animation3")
    }
    

    private func setupAnimationLayer() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.layer.addSublayer(layer)
        return layer
    }
    
     
    private func setupKeyframeAnimation(layer:CALayer,values:[Any] ,key:String)  {
        let animation = CAKeyframeAnimation(keyPath:"bounds.size.height")
        animation.values = values
        animation.duration = 1.5
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: key)
       
    }
}
