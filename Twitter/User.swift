//
//  User.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/3/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

var _currentUser: User?

let currentUserKey = "kCurrentUserKey"

class User: NSObject {
  
  var name: String = ""
  var screenname: String = ""
  var profileImageUrl: NSURL?
  var tagline: String = ""
  var rawDictionary: [String:AnyObject]?
  
  init(_ data: [String:AnyObject]) {
    rawDictionary = data
    
    if let value = data["name"] as? String {
      name = value
    }
    if let value = data["screen_name"] as? String {
      screenname = value
    }
    if let value = data["profile_image_url"] as? String {
      profileImageUrl = NSURL(string: value)
    }
    if let value = data["description"] as? String {
      tagline = value
    }
  }
  
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData {
          if let dictionary = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) {
            _currentUser = User(dictionary as! [String:AnyObject])
          }
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      
      if _currentUser != nil {
        let data = try? NSJSONSerialization.dataWithJSONObject(_currentUser?.rawDictionary as! AnyObject, options: NSJSONWritingOptions())
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
        
      } else {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
      }
    }
  }
}
