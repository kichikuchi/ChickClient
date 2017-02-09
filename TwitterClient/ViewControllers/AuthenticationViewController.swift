//
//  AuthenticationViewController.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/05.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import TwitterKit

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton { [weak self] (session, error) in
            if let _ = session {
                let viewController = TimelineViewController.fromStoryboard()
                self?.navigationController?.pushViewController(viewController, animated: true)
            } else {
                let alert = UIAlertController(title: nil,
                                              message: "Twitter認証に失敗しました。\n再度お試しください",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
}

