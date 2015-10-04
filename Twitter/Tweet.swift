//
//  Tweet.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/3/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  // TODO: Should these be optionals?
  let user: User?
  var text: String = ""
  let createdAt: NSDate?
  
  init(_ data: [String:AnyObject]) {
    user = User(data["user"] as! [String:AnyObject])
    
    if let value = data["text"] as? String {
      text = value
    }
    
    if let value = data["created_at"] as? String {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      createdAt = dateFormatter.dateFromString(value)
    } else {
      createdAt = nil
    }
  }
  
  class func tweetsWithArray(data: [AnyObject]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for tweetData in data {
      tweets.append(Tweet(tweetData as! [String:AnyObject]))
    }
    
    return tweets
  }
}
