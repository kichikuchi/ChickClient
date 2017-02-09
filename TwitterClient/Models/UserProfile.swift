//
//  UserProfile.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/08.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import Foundation

struct UserProfile {
    let description: String
    let bannerURL: URL?
    let followCount: Int
    let followeeCount: Int
    
    init(json: [String: Any]) {
        if let description = json["description"] as? String {
            self.description = description
        } else {
            self.description = ""
        }
        
        if let bannerURLString = json["profile_banner_url"] as? String, let bannerURL = URL(string: bannerURLString + "/mobile_retina") {
            self.bannerURL = bannerURL
        } else {
            self.bannerURL = nil
        }
        
        if let followCount = json["friends_count"] as? Int {
            self.followCount = followCount
        } else {
            self.followCount = 0
        }
        
        if let followeeCount = json["followers_count"] as? Int {
            self.followeeCount = followeeCount
        } else {
            self.followeeCount = 0
        }
    }
}
