//
//  SDKeyboardProtocol.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/20.
//

import UIKit

fileprivate var NotificationAssociateObjectHandle: UInt8 = 0

protocol SDKeyboardProtocol  {
    
    func notificationKeyboardWillShow()
}

extension SDKeyboardProtocol {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (note) in
            self.notificationKeyboardWillShow()
        }
    }
    
    
}



