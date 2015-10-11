//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

  var replyActionHandler: ((tweetId: String, tweetUserScreenname: String) -> ())?
  var userProfileShowHandler: ((user: User) -> ())?
  
  private var tweetView: TweetView!
  
  var tweet: Tweet! {
    didSet {
      tweetView.tweet = tweet
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
    tweetView = TweetView()
    tweetView.replyActionHandler = { (tweetId: String, tweetUserScreenname: String) -> Void in
      
      print("Replying to tweet id: \(tweetId)")
      print("Replying to screenname: \(tweetUserScreenname)")
      self.onReplyTap(tweetId, tweetScreenname: tweetUserScreenname)
    }
    tweetView.userProfileShowHandler = { (user: User) -> Void in
      
      self.onUserProfileTap(user)
    }
    contentView.addSubview(tweetView)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    tweetView.translatesAutoresizingMaskIntoConstraints = false
    
    let views = [
      "tweetView": tweetView,
    ]
    
    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tweetView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tweetView(>=140)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
  }
 
  func onReplyTap(tweetId: String, tweetScreenname: String) {
    if let replyActionHandler = self.replyActionHandler {
      replyActionHandler(tweetId: tweet.id, tweetUserScreenname: tweet.user!.screenname)
    }
  }
  
  func onUserProfileTap(user: User) {
    if let userProfileShowHandler = userProfileShowHandler {
      userProfileShowHandler(user: user)
    }
  }
  
  
}
