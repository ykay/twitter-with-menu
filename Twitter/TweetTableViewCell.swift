//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var profileThumbImageView: UIImageView!
  @IBOutlet weak var favoriteImageView: UIImageView!
  @IBOutlet weak var favoriteLabel: UILabel!
  @IBOutlet weak var replyImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!

  var tweet: Tweet! {
    didSet {
      nameLabel.text = tweet.user!.name
      screennameLabel.text = "@\(tweet.user!.screenname)"
      tweetTextLabel.text = tweet.text
      dateLabel.text = tweet.createdAt?.description
      profileThumbImageView.setImageWithURL(tweet.user!.profileImageUrl)
      
      if tweet.favorited {
        favoriteImageView.image = UIImage(named: "favorite_on.png")
        favoriteLabel.textColor = UIColor(red:0.99, green:0.61, blue:0.16, alpha:1.0)
      } else {
        favoriteImageView.image = UIImage(named: "favorite_hover.png")
        favoriteLabel.textColor = UIColor.lightGrayColor()
      }
      
      favoriteLabel.text = "\(tweet.favoriteCount)"
      
      if tweet.user!.name == User.currentUser!.name {
        retweetImageView.image = UIImage(named: "retweet.png")
      } else {
        if tweet.retweeted {
          retweetImageView.image = UIImage(named: "retweet_on.png")
        } else {
          retweetImageView.image = UIImage(named: "retweet_hover.png")
        }
      }
      
      /* Fade in code
      profileThumbImageView.setImageWithURLRequest(NSURLRequest(URL: tweet.user!.profileImageUrl!), placeholderImage: nil,
        success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
          let retrievedImage = image
          UIView.transitionWithView(self.profileThumbImageView, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { () -> Void in
              self.profileThumbImageView.image = retrievedImage
            },
            completion: nil)
          
        },
        failure: { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
          
        })*/
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
    profileThumbImageView.layer.cornerRadius = 10.0
    profileThumbImageView.clipsToBounds = true

    let replyTap = UITapGestureRecognizer(target: self, action: "onReplyTap")
    replyTap.numberOfTapsRequired = 1
    replyImageView.userInteractionEnabled = true
    replyImageView.addGestureRecognizer(replyTap)
    replyImageView.image = UIImage(named: "reply_hover.png")
    
    let retweetTap = UITapGestureRecognizer(target: self, action: "onRetweetTap")
    retweetTap.numberOfTapsRequired = 1
    // Disable if it's already been retweeted
    retweetImageView.userInteractionEnabled = true
    retweetImageView.addGestureRecognizer(retweetTap)
    
    // Make favorite image tap-able.
    let favoriteTap = UITapGestureRecognizer(target: self, action: "onFavoriteTap")
    favoriteTap.numberOfTapsRequired = 1
    favoriteImageView.userInteractionEnabled = true
    favoriteImageView.addGestureRecognizer(favoriteTap)
  }
  
  func onReplyTap() {
    print("Replied to \(tweet.id)")
    
  }
  
  func onRetweetTap() {
    // Only retweet if not own tweet
    if tweet.user!.name != User.currentUser!.name {
      
      // Only allow retweeting if it hasn't been retweeted yet.
      if !tweet.retweeted {
        TwitterClient.sharedInstance.retweet(tweet.id) { (data: [String:AnyObject]?, error: NSError?) -> Void in
          
          self.retweetImageView.image = UIImage(named: "retweet_on.png")
        }
      }
    } else {
      print("Can't retweet own tweet")
    }
  }
  
  func onFavoriteTap() {
    
    if tweet.favorited {
      TwitterClient.sharedInstance.unfavorite(tweet.id) { (data: [String:AnyObject]?, error: NSError?) -> Void in
        
        if let data = data {
          self.tweet = Tweet(data)
        }
      }
    } else {
      TwitterClient.sharedInstance.favorite(tweet.id) { (data: [String:AnyObject]?, error: NSError?) -> Void in
        
        if let data = data {
          self.tweet = Tweet(data)
        }
      }
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
