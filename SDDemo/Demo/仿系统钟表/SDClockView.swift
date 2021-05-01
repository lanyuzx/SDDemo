//
//  SDClockView.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/27.
//

import UIKit

//秒针一次转6度
private let secondsAngle = 6
//分针一次转6度
private let minuteAngle = 6
//时针一次转30度
private let hourAngle = 30.0

//时针1分钟转的度数
private let hourMinuteAngle = 0.5

class SDClockView: UIView {
    
    /// 秒针
    private var secondsLayer:CALayer?
    //分针
    private var minutesLayer:CALayer?
    //时针
    private var hourLayer:CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = .red
        SDTimerObserver.sharedInstance.addTimerObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SDTimerObserver.sharedInstance.removeTimerObserver(self)
    }
    
    private func setupUI() {
        addSubview(clockIV)
        clockIV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //秒针
        let secondsLayer = setupLayer()
        self.secondsLayer = secondsLayer
        secondsLayer.backgroundColor = UIColor.red.cgColor
        
        //分针
        let minutesLayer = setupLayer()
        self.minutesLayer = minutesLayer
        minutesLayer.backgroundColor = UIColor.darkGray.cgColor
        
        //时针
        let hourLayer = setupLayer()
        self.hourLayer = hourLayer
        hourLayer.backgroundColor = UIColor.darkGray.cgColor
        
        timerCallBack(timer: SDTimerObserver.sharedInstance)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        secondsLayer?.bounds = CGRect(x: 0, y: 0, width: 2, height: self.bounds.size.height / 2)
        secondsLayer?.position = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        minutesLayer?.bounds = CGRect(x: 0, y: 0, width: 4, height: self.bounds.size.height / 2 - 20)
        minutesLayer?.position = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        hourLayer?.bounds = CGRect(x: 0, y: 0, width: 6, height: self.bounds.size.height / 2 - 40)
        hourLayer?.position = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    private lazy var clockIV:UIImageView = {
       let clockIV = UIImageView(image: UIImage(named: "ic_clock"))
        return clockIV
    }()
    
    private let calendar = Calendar.current
}

extension SDClockView:TimerObserverDelegate {
    
    func timerCallBack(timer: SDTimerObserver) {
      
        let components = calendar.dateComponents([.hour,.minute,.second], from: Date())
        //获取当前的秒数
        let seconds = (components.second ?? 0) * secondsAngle
        self.secondsLayer?.transform = CATransform3DMakeRotation(angleToRadian(angle: CGFloat(seconds) ), 0, 0, 1)
        //获取当前分钟
        let minute = (components.minute ?? 0) * minuteAngle
        self.minutesLayer?.transform = CATransform3DMakeRotation(angleToRadian(angle: CGFloat(minute)), 0, 0, 1)
        
        //获取当前小时
        let hour = Double((components.hour ?? 0)) * hourAngle  + Double(components.minute ?? 0) * hourMinuteAngle
        self.hourLayer?.transform = CATransform3DMakeRotation(angleToRadian(angle: CGFloat(hour)), 0, 0, 1)
    }
    
    private func angleToRadian(angle:CGFloat) -> CGFloat {
        return angle / 180.0 * CGFloat(Double.pi)
    }
    
    private func setupLayer() -> CALayer {
        let layer = CALayer()
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.layer.addSublayer(layer)
       return layer
    }
}
