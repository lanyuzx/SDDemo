//
//  SDUIColor+Basic.swift
//  SDJG
//
//  Created by lucky on 2020/2/27.
//  Copyright © 2020 王俊. All rights reserved.
//

import UIKit
/**
- Brief UIColor扩展类 把AnyObject类型转成Color、根据rgb返回颜色、根据颜色十六进制代码获取颜色、把any类型内容转成Color
*/
extension UIColor {
    
  
    /// 根据rgb返回颜色
    /// - Parameter red: 红
    /// - Parameter green: 黄
    /// - Parameter blue: 蓝
    /// - Parameter alpha: 透明度
    public final class func extRGBA(red: CGFloat , green: CGFloat , blue: CGFloat , alpha: CGFloat = 1.0) -> UIColor{
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    /// 根据颜色十六进制代码获取颜色
    /// - Parameter hex: 十六进制代码值
    /// - Parameter alpha: 透明度
    public final class func extColorWithHex(_ hex : String, alpha: CGFloat = 1.0) -> UIColor{
        var hexColor = hex
        hexColor = hexColor.replacingOccurrences(of: " ", with: "")
        if(hexColor.hasPrefix("#")){
            hexColor = String(hexColor.suffix(from: hexColor.index(hexColor.startIndex, offsetBy: 1)))
        }
        let rStr = String(hexColor[hexColor.startIndex ..< hexColor.index(hexColor.startIndex, offsetBy: 2)])
        let gStr = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 2) ..< hexColor.index(hexColor.startIndex, offsetBy: 4)])
        let bStr = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 4) ..< hexColor.index(hexColor.startIndex, offsetBy: 6)])
        var r = uint()
        var g = uint()
        var b = uint()
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        let color : UIColor = UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        return color;
    }
    
    /// 颜色转UIImage
    /// - Parameter size: 尺寸
    public func extTransImage(_ size: CGSize) -> UIImage? {
        var resultImage: UIImage? = nil
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return resultImage
        }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    

}
