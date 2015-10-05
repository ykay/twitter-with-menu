//
//  TwitterClient.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/1/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let userLoginNotification = "userLoginNotification"
let userLogoutNotification = "userLogoutNotification"

private let twitterConsumerKey = "rCR1szO5RrohQDz3tAigPsXFJ"
private let twitterConsumerSecret = "kRaUPVtvjrF5HVOb5G4YaBwUyAI27pU9Un7bkjZKRWg2qZwnLr"
private let twitterBaseUrl = "https://api.twitter.com"

class TwitterClient: BDBOAuth1RequestOperationManager {
  
  static let sharedInstance = TwitterClient(baseURL: NSURL(string: twitterBaseUrl), consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
  
  var loginCompletion: ((User?, NSError?) -> Void)?
  
  func login(completion: (User?, NSError?) -> Void) {
    loginCompletion = completion
    
    // Remove access token from previous logged on session
    requestSerializer.removeAccessToken()
    fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterclient://oauth"), scope: nil,
      success: { (requestToken: BDBOAuth1Credential!) -> Void in
        print("Got the request token!")
        
        let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
        UIApplication.sharedApplication().openURL(authUrl!)
      },
      failure: { (error: NSError!) -> Void in
        print("Failed to get the request token")
        
        self.loginCompletion?(nil, error)
      }
    )
  }
  
  func logout() {
    User.currentUser = nil
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    
    NSNotificationCenter.defaultCenter().postNotificationName(userLogoutNotification, object: nil)
  }
  
  func homeTimelineWithParams(params: [String:AnyObject]?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
    GET("1.1/statuses/home_timeline.json", parameters: nil,
      success: { (request: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
        
        completion(tweets: Tweet.tweetsWithArray(data as! [AnyObject]), error: nil)
      
      },
      failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
        completion(tweets: nil, error: error)
    })
  }
  
  func favorite(id: String, completion: (data: [String:AnyObject]?, error: NSError?) -> Void) {
    let params = [ "id":id ]
    
    POST("1.1/favorites/create.json", parameters: params,
      success: { (request: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
        
        completion(data: data as? [String:AnyObject], error: nil)
      },
      failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
        
        completion(data: nil, error: error)
      })
  }
  
  func unfavorite(id: String, completion: (data: [String:AnyObject]?, error: NSError?) -> Void) {
    let params = [ "id" : id ]
    
    POST("1.1/favorites/destroy.json", parameters: params,
      success: { (request: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
        
        completion(data: data as? [String:AnyObject], error: nil)
      },
      failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
        
        completion(data: nil, error: error)
    })
  }
  
  func tweet(text: String, inReplyToStatusId: String?, completion: (data: [String:AnyObject]?, error: NSError?) -> Void) {
    var params = [ "status" : text ]
    
    if inReplyToStatusId != nil {
      params["in_reply_to_status_id"] = inReplyToStatusId
    }
    
    POST("1.1/statuses/update.json", parameters: params,
      success: { (request: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
        
        completion(data: data as? [String:AnyObject], error: nil)
      },
      failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
        
        completion(data: nil, error: error)
    })
  }
  
  func retweet(id: String, completion: (data: [String:AnyObject]?, error: NSError?) -> Void) {
    
    POST("1.1/statuses/retweet/\(id).json", parameters: nil,
      success: { (request: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
        
        completion(data: data as? [String:AnyObject], error: nil)
      },
      failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
        
        completion(data: nil, error: error)
    })
  }
  
  func openURL(url: NSURL) {
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query!),
      success: { (accessToken: BDBOAuth1Credential!) -> Void in
        print("Got the access token!")
        
        self.requestSerializer.saveAccessToken(accessToken)
        
        self.GET("1.1/account/verify_credentials.json", parameters: nil,
          success: { (request: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
            
            let user = User(data as! [String:AnyObject])
            print("user name: \(user.name)")
            
            User.currentUser = user
            
            self.loginCompletion?(user, nil)
          },
          failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Failed to get user data")
            self.loginCompletion?(nil, error)
        })
      },
      failure: {
        (error: NSError!) -> Void in
        print("Failed to get the access token!")
        self.loginCompletion?(nil, error)
    })
    
  }
}
