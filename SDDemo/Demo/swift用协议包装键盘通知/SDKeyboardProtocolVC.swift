//
//  SDKeyboardProtocol.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/20.
//

import UIKit

class SDKeyboardProtocolVC: SDBaseVC , SDKeyboardProtocol {
   
    
    
    var tf:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tf = UITextField()
        self.tf  = tf
        view.addSubview(tf)
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        tf.placeholder = "请输入"
        tf.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(45)
        }
        self.addKeyboardObserver()
     
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tf?.endEditing(true)
    }
    
    func notificationKeyboardWillShow() {
        
    }
    
    func notificationKeyboardDidShow() {
        
    }
    
    func notificationKeyboardDidChangeFrame(notification: Notification) {
        
    }
    
    func notificationKeyboardDidHide() {
        
    }
    

}
