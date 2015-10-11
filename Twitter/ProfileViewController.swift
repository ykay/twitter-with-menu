//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/8/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  @IBOutlet weak var profileBackgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetsCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var timelineTableView: UITableView!
  
  var tweets = [Tweet]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    nameLabel.text = User.currentUser!.name
    screennameLabel.text = "@" + User.currentUser!.screenname
    tweetsCountLabel.text = "\(User.currentUser!.tweetsCount)"
    followersCountLabel.text = "\(User.currentUser!.followersCount)"
    followingCountLabel.text = "\(User.currentUser!.followingCount)"
    profileBackgroundImageView.setImageWithURL(User.currentUser!.profileBannerUrl)
    profileImageView.setImageWithURL(User.currentUser!.profileImageUrl)
    profileImageView.layer.cornerRadius = 10.0
    
    timelineTableView.delegate = self
    timelineTableView.dataSource = self
    timelineTableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
    timelineTableView.rowHeight = UITableViewAutomaticDimension
    timelineTableView.estimatedRowHeight = 140
    
    TwitterClient.sharedInstance.userTimelineWithParams(nil) { (tweets, error) -> Void in
      if error == nil {
        if let tweets = tweets {
          self.tweets = tweets
          self.timelineTableView.reloadData()
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onReplyTap(tweetId: String, tweetUserScreenname: String) {
    
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = timelineTableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
    
    cell.tweet = tweets[indexPath.row]
    cell.replyActionHandler = { (tweetId: String, tweetUserScreenname: String) -> Void in
      self.onReplyTap(tweetId, tweetUserScreenname: tweetUserScreenname)
    }
    
    return cell
  }
}