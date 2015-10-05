//
//  Tweet.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/3/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  // TODO: User should be User!, not optional!!
  let user: User?
  var text: String = ""
  var id: String = ""
  let createdAt: NSDate?
  var favorited = false
  var favoriteCount = 0
  let rawDictionary: [String:AnyObject]?
  
  init(_ data: [String:AnyObject]) {
    rawDictionary = data
    
    user = User(data["user"] as! [String:AnyObject])
    
    if let value = data["text"] as? String {
      text = value
    }
    
    if let value = data["id_str"] as? String {
      id = value
    }
    
    if let value = data["created_at"] as? String {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      createdAt = dateFormatter.dateFromString(value)
    } else {
      createdAt = nil
    }
    
    if let value = data["favorited"] as? Bool {
      favorited = value
    }
    
    if let value = data["favorite_count"] as? Int {
      favoriteCount = value
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
