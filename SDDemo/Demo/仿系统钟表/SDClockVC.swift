//
//  SDClockVC.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/27.
//

import UIKit

class SDClockVC: SDBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let clockView = SDClockView()
        view.addSubview(clockView)
        clockView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(225)
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
