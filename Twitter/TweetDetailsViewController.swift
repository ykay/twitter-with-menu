//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
  @IBOutlet weak var profileThumbImageView: UIImageView!  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var favoriteImageView: UIImageView!
  @IBOutlet weak var favoriteLabel: UILabel!
  @IBOutlet weak var replyImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!
  
  var tweet: Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
    
    // So text box doesn't extend beyond navigation bar
    self.edgesForExtendedLayout = UIRectEdge.None
    
    reload()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func reload() {
    nameLabel.text = tweet.user!.name
    screennameLabel.text = "@\(tweet.user!.screenname)"
    tweetTextLabel.text = tweet.text
    dateLabel.text = tweet.createdAt?.description
    profileThumbImageView.setImageWithURL(tweet.user!.profileImageUrl)
    
    // Make favorite image tap-able.
    let favoriteTap = UITapGestureRecognizer(target: self, action: "onFavoriteTap")
    favoriteTap.numberOfTapsRequired = 1
    favoriteImageView.userInteractionEnabled = true
    favoriteImageView.addGestureRecognizer(favoriteTap)
    
    if tweet.favorited {
      favoriteImageView.image = UIImage(named: "favorite_on.png")
      favoriteLabel.textColor = UIColor(red:0.99, green:0.61, blue:0.16, alpha:1.0)
    } else {
      favoriteImageView.image = UIImage(named: "favorite_hover.png")
      favoriteLabel.textColor = UIColor.lightGrayColor()
    }
    
    favoriteLabel.text = "\(tweet.favoriteCount)"
    
    let retweetTap = UITapGestureRecognizer(target: self, action: "onRetweetTap")
    retweetTap.numberOfTapsRequired = 1
    // Disable if it's already been retweeted
    retweetImageView.userInteractionEnabled = true
    retweetImageView.addGestureRecognizer(retweetTap)
    
    if tweet.user!.name == User.currentUser!.name {
      retweetImageView.image = UIImage(named: "retweet.png")
    } else {
      if tweet.retweeted {
        retweetImageView.image = UIImage(named: "retweet_on.png")
      } else {
        retweetImageView.image = UIImage(named: "retweet_hover.png")
      }
    }
    
    let replyTap = TweetTapGestureRecognizer(target: self, action: "onReplyTap:")
    replyTap.numberOfTapsRequired = 1
    // Add tap handler for cell here, since we need to push a view controller from here.
    replyImageView.userInteractionEnabled = true
    replyImageView.addGestureRecognizer(replyTap)
    replyImageView.image = UIImage(named: "reply_hover.png")
  }
  
  func onCancel() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func onReplyTap(sender: AnyObject!) {
    let tweetTap = sender as! TweetTapGestureRecognizer
    
    print("Replying to tweet id: \(tweetTap.id)")
    print("Replying to screenname: \(tweetTap.screenname)")
    let composeViewController = ComposeViewController(inReplyToStatusId: tweet.id, inReplyToScreenname: tweet.user!.screenname)
    
    navigationController?.pushViewController(composeViewController, animated: true)
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
          self.reload()
        }
      }
    } else {
      TwitterClient.sharedInstance.favorite(tweet.id) { (data: [String:AnyObject]?, error: NSError?) -> Void in
        
        if let data = data {
          self.tweet = Tweet(data)
          self.reload()
        }
      }
    }
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
