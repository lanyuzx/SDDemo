//
//  SDPlayAnimationVC.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/25.
//

import UIKit

class SDPlayAnimationVC: SDBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        let playAnimation = SDPlayAnimationView.playAnimationView()
        playAnimation.backgroundColor = .red
        playAnimation.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        playAnimation.center = self.view.center
        view.addSubview(playAnimation)
        playAnimation.startAnimation()
        
    }
}
