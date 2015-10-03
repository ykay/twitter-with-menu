//
//  User.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/3/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class User: NSObject {
  
  var name: String = ""
  var screenname: String = ""
  var profileImageUrl: String = ""
  var tagline: String = ""
  
  init(_ data: [String:AnyObject]) {
    if let value = data["name"] as? String {
      name = value
    }
    if let value = data["screen_name"] as? String {
      screenname = value
    }
    if let value = data["profile_image_url"] as? String {
      profileImageUrl = value
    }
    if let value = data["description"] as? String {
      tagline = value
    }
  }
}
