//
//  TweetView.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/10/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class TweetView: UIView {
  var nameLabel: UILabel!
  var screennameLabel: UILabel!
  var tweetTextLabel: UILabel!
  var dateLabel: UILabel!
  var favoriteLabel: UILabel!
  var profileThumbImageView: UIImageView!
  var favoriteImageView: UIImageView!
  var retweetImageView: UIImageView!
  var replyImageView: UIImageView!
  
  var replyActionHandler: ((tweetId: String, tweetUserScreenname: String) -> ())?
  
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

  
  // Since super.init(coder) is failable, we must conform to that.
  init?(_ coder: NSCoder?, frame: CGRect?) {

    if let coder = coder {
      super.init(coder: coder)
    } else {
      super.init(frame: frame ?? CGRectZero)
    }
    
    setupSubviews()
    setupConstraints()
  }
  
  override convenience init(frame: CGRect) {
    // Since we won't call the failable init(coder), we know this call will never fail, thus the '!' force unwrap is okay.
    self.init(nil, frame: frame)!
  }

  required convenience init?(coder: NSCoder) {
    self.init(coder, frame: nil)
  }
  
  func setupSubviews() {
    nameLabel = UILabel()
    nameLabel.font = UIFont.boldSystemFontOfSize(13.0)
    addSubview(nameLabel)
    
    screennameLabel = UILabel()
    screennameLabel.font = UIFont.systemFontOfSize(11.0)
    screennameLabel.textColor = UIColor.lightGrayColor()
    addSubview(screennameLabel)
    
    tweetTextLabel = UILabel()
    tweetTextLabel.font = UIFont.systemFontOfSize(16)
    tweetTextLabel.numberOfLines = 0
    addSubview(tweetTextLabel)
    
    dateLabel = UILabel()
    dateLabel.font = screennameLabel.font
    dateLabel.textColor = screennameLabel.textColor
    addSubview(dateLabel)
    
    favoriteLabel = UILabel()
    favoriteLabel.font = UIFont.systemFontOfSize(10.0)
    addSubview(favoriteLabel)
    
    profileThumbImageView = UIImageView()
    addSubview(profileThumbImageView)
    
    favoriteImageView = UIImageView()
    addSubview(favoriteImageView)
    
    retweetImageView = UIImageView()
    addSubview(retweetImageView)
    
    replyImageView = UIImageView()
    replyImageView.image = UIImage(named: "reply_hover.png")
    addSubview(replyImageView)
    
    
    // Other initialization steps
    profileThumbImageView.layer.cornerRadius = 10.0
    profileThumbImageView.clipsToBounds = true
    
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
    
    let replyTap = UITapGestureRecognizer(target: self, action: "onReplyTap")
    replyTap.numberOfTapsRequired = 1
    replyImageView.userInteractionEnabled = true
    replyImageView.addGestureRecognizer(replyTap)
  }
  
  func setupConstraints() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    screennameLabel.translatesAutoresizingMaskIntoConstraints = false
    tweetTextLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
    profileThumbImageView.translatesAutoresizingMaskIntoConstraints = false
    favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
    retweetImageView.translatesAutoresizingMaskIntoConstraints = false
    replyImageView.translatesAutoresizingMaskIntoConstraints = false
    
    let views = [
      "nameLabel":nameLabel,
      "screennameLabel":screennameLabel,
      "tweetTextLabel":tweetTextLabel,
      "dateLabel":dateLabel,
      "favoriteLabel":favoriteLabel,
      "profileThumbImageView":profileThumbImageView,
      "favoriteImageView":favoriteImageView,
      "retweetImageView":retweetImageView,
      "replyImageView":replyImageView,
    ]
    
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(11)-[profileThumbImageView(65)]-(11)-[nameLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(8)-[profileThumbImageView(65)]-(8)-[tweetTextLabel]-(8)-[dateLabel]-(10)-[replyImageView(16)]-(>=8)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[tweetTextLabel]-(>=8)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    
    addConstraint(NSLayoutConstraint(item: screennameLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: nameLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: tweetTextLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: profileThumbImageView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: profileThumbImageView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
      
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(8)-[nameLabel]-(8)-[screennameLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(48)-[replyImageView(16)]-(48)-[retweetImageView(16)]-(48)-[favoriteImageView(16)]-(2)-[favoriteLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[retweetImageView(16)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[favoriteImageView(16)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    addConstraint(NSLayoutConstraint(item: retweetImageView, attribute: .Top, relatedBy: .Equal, toItem: replyImageView, attribute: .Top, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: favoriteImageView, attribute: .Top, relatedBy: .Equal, toItem: replyImageView, attribute: .Top, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: favoriteLabel, attribute: .Top, relatedBy: .Equal, toItem: favoriteImageView, attribute: .Top, multiplier: 1.0, constant: 0))
    

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
  
  func onReplyTap() {
    if let replyActionHandler = self.replyActionHandler {
      replyActionHandler(tweetId: tweet.id, tweetUserScreenname: tweet.user!.screenname)
    }
  }  
}
