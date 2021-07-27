//
//  SDKeyboardProtocol.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/20.
//

import UIKit

fileprivate var NotificationAssociateObjectHandle: UInt8 = 0

protocol SDKeyboardProtocol : NSObjectProtocol  {
    
    
    func notificationKeyboardWillShow()
    
    func notificationKeyboardDidShow()
    
    func notificationKeyboardDidChangeFrame(notification:Notification)
    
    func notificationKeyboardDidHide()
}

extension SDKeyboardProtocol {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (note) in
            self.notificationKeyboardWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { (note) in
            self.notificationKeyboardDidShow()
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: nil) { (note) in
            self.notificationKeyboardDidChangeFrame(notification: note)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { (note) in
            self.notificationKeyboardDidHide()
        }
    }
    
    
}



