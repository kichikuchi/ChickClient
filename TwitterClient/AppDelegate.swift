//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/05.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Twitter.self])

        window?.rootViewController = LaunchManager.firstViewController()
        window?.makeKeyAndVisible()

        return true
    }
}

