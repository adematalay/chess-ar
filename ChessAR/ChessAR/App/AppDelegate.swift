//
//  AppDelegate.swift
//  ChessAR
//
//  Created by Adem Atalay on 2.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: AppRouter = AppRouter()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

