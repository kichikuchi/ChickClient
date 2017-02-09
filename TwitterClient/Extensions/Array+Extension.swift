//
//  Array+Extension.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/07.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    var unique: [Element] {
        return reduce([]) { $0.0.contains($0.1) ? $0.0 : $0.0 + [$0.1] }
    }
}
