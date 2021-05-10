//
//  SDQQViscousVC.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/9.
//仿QQ消息粘性

import UIKit

class SDQQBageValueVC: SDBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
         
        let bageValueButton = SDBageValueButton()
        bageValueButton.frame.origin = view.center
        bageValueButton.frame.size = CGSize(width: 20, height: 20)
        view.addSubview(bageValueButton)
        //不知道为啥使用自动布局不能拖动
//        bageValueButton.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(20)
//        }
    }

}
