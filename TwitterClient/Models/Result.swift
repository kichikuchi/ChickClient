//
//  Result.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/10.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import Foundation

enum Result<Value> {
    case Success(Value)
    case Failure(NSError)
    
    init(_ value: Value) {
        self = .Success(value)
    }
    
    init(_ error: NSError) {
        self = .Failure(error)
    }
}
