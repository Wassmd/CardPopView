//
//  AppDelegate.swift
//  CardDemo
//
//  Created by Mohammed Wasimuddin on 03.10.19.
//  Copyright © 2019 Wasim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ViewController()
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

