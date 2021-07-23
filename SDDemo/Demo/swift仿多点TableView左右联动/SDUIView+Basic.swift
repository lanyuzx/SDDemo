//
//  SDUIView+Basic.swift
//  SDJG
//
//  Created by lucky on 2020/2/26.
//  Copyright © 2020 王俊. All rights reserved.
//

import UIKit
/**
 - brief  UIView扩展类，扩展方法有：设置UIView部分圆角的扩展方法 滚动视图转图片、开启自动布局、设置圆角、边框、颜色、透明度、获取视图坐标属性、弹出模态视图控制器、截图（长屏和单屏）
*/
extension UIView {

    
    //MARK: 获取当视图x值
    /// 获取当视图x值
    public var extX : CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newValue
            frame                 = tmpFrame
        }
    }
    
    /// 获取当视图y值
    public var extY : CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newValue
            frame                 = tmpFrame
        }
    }
    
    /// 获取当视图y值
    public var extHeight : CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newValue
            frame                 = tmpFrame
        }
    }
    
    /// 获取当视图y值
    public var extWidth : CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newValue
            frame                 = tmpFrame
        }
    }

    /// 获取当视图右边值
    public var extMaxX : CGFloat {
        get {
            return extX + extWidth
        }
        set(newValue) {
            extX = newValue - extWidth
        }
    }
        
    /// 获取当视图底部值
    public var extMaxY : CGFloat {
        get {
            return extY + extHeight
        }
        set(newValue) {
            extY = newValue - extHeight
        }
    }
    
    /// 获取当视图中心点x值
    public var extCenterX : CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    
    /// 获取当视图中心点y值
    public var extCenterY : CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    /// 获取当视图大小
    public var extSize : CGSize {
        get {
            return frame.size
        }
        set(newValue){
            var tmpFrame : CGRect = frame
            tmpFrame.size         = newValue
            frame                 = tmpFrame
        }
    }
    
    // 获取当视图y值
    public var extOrigin : CGPoint {
        get {
            return frame.origin
        }
        set(newValue){
            var tmpFrame : CGRect = frame
            tmpFrame.origin       = newValue
            frame                 = tmpFrame
        }
    }
    
    /// 部分圆角
    /// - Parameter corners: 需要实现为圆角的角，可传入多个
    /// - Parameter radii: 圆角半径
    public func extCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 开启自动布局
    public final func extUseAutoLayout(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 设置圆角
    /// - Parameter radius: 圆角半径 必须
    public final func extSetCornerRadius(_ radius : CGFloat ) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    /// 设置视图边框以及颜色
    /// - Parameter width: 边框大小 必须
    /// - Parameter color: 颜色 必须
    public final func extSetBorderWidth(_ width : CGFloat , color : UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    /// 设置视图边框、颜色及圆角
    /// - Parameter width: 边框大小 必须
    /// - Parameter color: 颜色 必须
    public final func extSetBorderWidthAndRadius(_ width : CGFloat , color : UIColor, radius: CGFloat, isMasksToBound: Bool = false) {
        self.extSetBorderWidth(width, color: color)
        self.layer.masksToBounds = isMasksToBound
        self.layer.cornerRadius = radius
    }
    
    /// 设置阴影 - 颜色 偏移 透明度
    /// - Parameter color: 颜色
    /// - Parameter shadowOffset: 偏移量
    /// - Parameter opacity: 透明度
    /// - Parameter shadowRadius: 阴影角度
    public final func extSetShadowColor(_ color : UIColor , shadowOffset : CGSize , opacity : Float , shadowRadius:CGFloat = 1.0 ){
        self.layer.shadowOffset = shadowOffset;
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius;
    }
    
    /// 弹出模态视图控制器
    /// - Parameter vc: 控制器
    /// - Parameter backgroundColor: 背景色 可不传 有默认值
    /// - Parameter animated: 是否动画 可不传 有默认值 默认无动画
    public final func extShowModalVC(_ vc :UIViewController , backgroundColor :UIColor = UIColor.extRGBA(red: 66.0, green: 66.0, blue: 66.0, alpha: 0.4) , animated :Bool = false){
        guard let appDelegate = UIApplication.shared.delegate else { return }
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        if appDelegate.window != nil   {
            appDelegate.window??.rootViewController!.present(vc, animated: animated, completion: {
                // 背景色 透明
                vc.view.backgroundColor  = backgroundColor
            })
        }
    }
    
    /// 移除阴影-工具类提过来的
    public final func extRemoveShadowForView() {
        self.layer.shadowColor = nil
        self.layer.shadowOpacity = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowOffset = CGSize.zero
    }
    
    /// 添加阴影-工具类提过来的
    public final func extAddShadowForView(shadowColor: UIColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0),
                                       shadowOpacity: Float = 1,
                                       shadowRadius: CGFloat = 5,
                                       shadowOffset: CGSize = CGSize(width: 1, height: 1)) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    /// 添加渐变色背景
    public final func extSetGradientLayerForView(firstColor: UIColor, secColor: UIColor, frame: CGRect, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 0)) {
        let GTLayer : CAGradientLayer =  CAGradientLayer()
        GTLayer.startPoint = startPoint
        GTLayer.endPoint = endPoint
        GTLayer.colors = [firstColor.cgColor, secColor.cgColor]
        GTLayer.frame = frame
        self.layer.insertSublayer(GTLayer, at: 0)
    }
}
