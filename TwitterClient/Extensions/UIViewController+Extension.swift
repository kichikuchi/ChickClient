//
//  UIViewController+Extension.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/05.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit

// MARK: - static
extension UIViewController {
    static func fromStoryboard() -> UIViewController {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardName)
    }
}

// MARK: - instance
extension UIViewController {
    func showAPIErrorAlert(error: NSError) {
        var errorMessage = "ネットワークエラー。\n通信状況の良い場所で再度お試しください。"
        
        if let errorCode = error.userInfo["TWTRNetworkingStatusCode"] as? Int {
            switch errorCode {
            case 401:
                errorMessage = "認証エラー。\n有効なアカウントでログインしてお試しください。"
            case 429:
                errorMessage = "APIのアクセス制限。\nしばらく待ってから再度お試しください。"
            case 500:
                errorMessage = "メンテナンス中。\n しばらく待ってから再度お試しください。"
            default: break
            }
        }
        
        
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func navigationBarAppearance(isHidden: Bool) {
        
        guard let navigationController = navigationController else {
            return
        }
        
        if isHidden {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.tintColor = .white
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            navigationController.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController.navigationBar.shadowImage = nil
            navigationController.navigationBar.tintColor = UIWindow.appearance().tintColor
            UIApplication.shared.statusBarStyle = .default
        }
    }
}
