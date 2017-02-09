//
//  UserIconImageView.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/08.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit

class UserIconImageView: UIImageView {
    override func awakeFromNib() {
        clipsToBounds = true
        layer.cornerRadius = 3.0
    }
}
