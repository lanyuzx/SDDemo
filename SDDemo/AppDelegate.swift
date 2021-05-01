//
//  AppDelegate.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let navVC = UINavigationController(rootViewController: SDDemoVC())
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

