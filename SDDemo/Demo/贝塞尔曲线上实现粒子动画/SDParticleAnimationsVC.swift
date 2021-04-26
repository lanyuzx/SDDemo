//
//  SDParticleAnimationsVC.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/25.
//

import UIKit

class SDParticleAnimationsVC: SDBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let particleView = SDParticleAnimationsView()
        view.addSubview(particleView)
        particleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
