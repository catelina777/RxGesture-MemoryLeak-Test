//
//  AppDelegate.swift
//  RxGesture-MemoryLeak-Test
//
//  Created by Ryuhei Kaminishi on 2019/06/15.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let vc = Test2ViewController()
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        window.makeKeyAndVisible()
        return true
    }
}

