//
//  UILabelUtil.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/07.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import UIKit

class UILabelUtil {
    static func labelHeight(with string: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 100.0))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.text = string
        label.sizeToFit()
        return ceil(label.frame.height)
    }
}
