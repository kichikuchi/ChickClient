//
//  LaunchManager.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/05.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import TwitterKit

class LaunchManager {
    static func firstViewController() -> UINavigationController {
        let viewController: UIViewController
        
        if let _ = Twitter.sharedInstance().sessionStore.session() {
            viewController = TimelineViewController.fromStoryboard()
        } else {
            viewController = AuthenticationViewController.fromStoryboard()
        }

        return UINavigationController(rootViewController: viewController)
    }
}
