//
//  UserTweetManager.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/07.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import TwitterKit

class UserTweetManager {
    fileprivate var tweets: [TWTRTweet] = []
    
    var tweetCount: Int {
        return tweets.count
    }
    
    fileprivate var lastID: String?
    fileprivate var downloading = false
    let user: TWTRUser
    
    init(user: TWTRUser) {
        self.user = user
    }
    
    subscript (index: Int) -> TWTRTweet {
        get {
            assert(tweetCount > index, "index out of range")
            return tweets[index]
        }
    }
}

// MARK: - public
extension UserTweetManager {
    
    func reset() {
        lastID = nil
    }
    
    func shouldDownload(at indexPath: IndexPath) -> Bool {
        guard !downloading else {
            return false
        }
        
        // 少し早めに次ページをダウンロードさせる
        return tweetCount == indexPath.row + 10
    }
    
    func getUserTimeline(completion: @escaping ((response: Result<[TWTRTweet]>)) -> ()) {
        
        downloading = true
        
        TwitterAPIClient.getUserTimeline(userID: user.userID, lastID: lastID) { [weak self] result in
            
            self?.downloading = false
            
            switch result {
            case .Success(let value):
                if let _ = self?.lastID {
                    
                    self?.tweets += value
                    
                    // 最後のtweetが重複するのでuniqueなarrayを入れ直す
                    if let uniqueArray = self?.tweets.unique {
                        self?.tweets = uniqueArray
                    }
                    
                } else {
                    self?.tweets = value
                }
                
                if let lastTweet = self?.tweets.last {
                    self?.lastID = lastTweet.tweetID
                }
            case .Failure(_): break
            }
            
            completion(result)
        }
    }
}
