//
//  Math.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/10.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import Foundation

class Math {
    static func map(value: Double, inMin inMin: Double, inMax inMax: Double, outMin outMin: Double, outMax outMax: Double) -> Double {
        return (value - inMin) / (inMax - inMin) * (outMax - outMin) + outMin
    }
}
