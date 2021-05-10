//
//  SDQQViscousVC.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/9.
//仿QQ消息粘性

import UIKit

class SDQQBageValueVC: SDBaseVC {
    
    var bageValueButton: SDBageValueButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        bageValueButton = SDBageValueButton()
        bageValueButton?.frame.origin = view.center
        bageValueButton?.frame.size = CGSize(width: 20, height: 20)
        view.addSubview(bageValueButton!)
        
    }
    
    //重置操作
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let filter = view.subviews.filter { (item) -> Bool in
            return item == bageValueButton
        }
        if filter.count == 0 {
            setup()
        }
    }
}
