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
        view.addSubview(bageValueButton)
        bageValueButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }

}
