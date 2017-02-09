//
//  OpenURLUtil.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/10.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit
import SafariServices

class OpenURLUtil {
    static func openURL(_ url: URL, with viewController: UIViewController) {
        if #available(iOS 9.0, *) {
            let safariViewController = SFSafariViewController(url: url)
            viewController.present(safariViewController, animated: true, completion: nil)
        } else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
