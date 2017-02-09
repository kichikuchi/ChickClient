//
//  TwitterAPIClient.swift
//  TwitterClient
//
//  Created by Kazunori Kikuchi on 2017/02/06.
//  Copyright © 2017年 kazunori kikuchi. All rights reserved.
//

import TwitterKit

class TwitterAPIClient {
    static let baseURL = "https://api.twitter.com/"
    static let apiVersion = "1.1/"
    
    enum HTTPMethod {
        case get
        
        func methodString() -> String {
            switch self {
            case .get:
                return "GET"
            }
        }
    }
}

extension TwitterAPIClient {
    
    static func getTimeline(lastID: String? = nil, completion: @escaping ((response: Result<[TWTRTweet]>)) -> ()) {
        
        let urlString = baseURL + apiVersion + "statuses/home_timeline.json"
        let client = TWTRAPIClient.withCurrentUser()
        var error: NSError?
        
        var parameters: [AnyHashable : Any]?
        if let lastID = lastID {
            parameters = ["max_id": lastID]
        }
        
        let request = client.urlRequest(withMethod: HTTPMethod.get.methodString(), url: urlString, parameters: parameters, error: &error)
        
        client.sendTwitterRequest(request) { (_, data, error) in
            guard let data = data else {
                completion(Result.Failure(error as! NSError))
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data) as! [Any]
            let tweets = TWTRTweet.tweets(withJSONArray: json) as! [TWTRTweet]
            completion(Result.Success(tweets))
        }
    }
    
    
    static func getUserTimeline(userID: String, lastID: String? = nil, completion: @escaping ((response: Result<[TWTRTweet]>)) -> ()) {

        let urlString = baseURL + apiVersion + "statuses/user_timeline.json"
        let client = TWTRAPIClient.withCurrentUser()
        var error: NSError?
        
        var parameters: [AnyHashable : Any]?
        if let lastID = lastID {
            parameters = ["max_id": lastID, "user_id": userID]
        } else {
            parameters = ["user_id": userID]
        }
        
        let request = client.urlRequest(withMethod: HTTPMethod.get.methodString(), url: urlString, parameters: parameters, error: &error)
        
        client.sendTwitterRequest(request) { (_, data, error) in
            guard let data = data else {
                completion(Result.Failure(error as! NSError))
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data) as! [Any]
            let tweets = TWTRTweet.tweets(withJSONArray: json) as! [TWTRTweet]
            completion(Result.Success(tweets))
        }
    }
    
    static func getUserDescription(userID: String, completion: @escaping ((response: Result<UserProfile>)) -> ()) {
        
        let urlString = baseURL + apiVersion + "users/show.json"
        let client = TWTRAPIClient.withCurrentUser()
        var error: NSError?
        
        let request = client.urlRequest(withMethod: HTTPMethod.get.methodString(), url: urlString, parameters: ["user_id": userID], error: &error)
        
        client.sendTwitterRequest(request) { (_, data, error) in
            guard let data = data else {
                completion(Result.Failure(error as! NSError))
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            completion(Result.Success(UserProfile(json: json)))
        }
    }
}
