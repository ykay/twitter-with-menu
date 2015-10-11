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
  var user: User?
  
  required init?(_ coder: NSCoder?, user: User?) {
    
    if let coder = coder {
      super.init(coder: coder)
    } else {
      super.init(nibName: nil, bundle: nil)
    }

    self.user = user
  }
  
  convenience init(user: User) {
    self.init(nil, user: user)!
  }
 
  required convenience init?(coder: NSCoder) {
    self.init(coder, user: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdge.None
    
    timelineTableView.delegate = self
    timelineTableView.dataSource = self
    timelineTableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
    timelineTableView.rowHeight = UITableViewAutomaticDimension
    timelineTableView.estimatedRowHeight = 140
    
    if let user = user {
      nameLabel.text = user.name
      screennameLabel.text = "@" + user.screenname
      tweetsCountLabel.text = "\(user.tweetsCount)"
      followersCountLabel.text = "\(user.followersCount)"
      followingCountLabel.text = "\(user.followingCount)"
      profileBackgroundImageView.setImageWithURL(user.profileBannerUrl)
      profileImageView.setImageWithURL(user.profileImageUrl)
      profileImageView.layer.cornerRadius = 10.0
      profileImageView.layer.masksToBounds = true
      profileImageView.layer.borderWidth = 2.0
      profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
      
      let parameters: [String:AnyObject] = [
        "screen_name":user.screenname
      ]
      
      TwitterClient.sharedInstance.userTimelineWithParams(parameters) { (tweets, error) -> Void in
        if error == nil {
          if let tweets = tweets {
            self.tweets = tweets
            self.timelineTableView.reloadData()
          }
        }
      }
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onReplyTap(tweetId: String, tweetUserScreenname: String) {
    let composeViewController = ComposeViewController(inReplyToStatusId: tweetId, inReplyToScreenname: tweetUserScreenname)
    
    navigationController?.pushViewController(composeViewController, animated: true)
  }
  
  func onUserProfileTap(user: User) {
    let profileViewController = ProfileViewController(user: user)
    
    navigationController?.pushViewController(profileViewController, animated: true)
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
    cell.userProfileShowHandler = { (user: User) -> Void in
      self.onUserProfileTap(user)
    }
    
    return cell
  }
}