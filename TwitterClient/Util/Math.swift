//
//  Math.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/10.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import Foundation

class Math {
    static func map(value: Double, inmin: Double, inmax: Double, outmin: Double, outmax: Double) -> Double {
        return (value - inmin) / (inmax - inmin) * (outmax - outmin) + outmin
    }
}
