//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {  
  var tweetView: TweetView!
  var tweet: Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
    
    // So text box doesn't extend beyond navigation bar
    self.edgesForExtendedLayout = UIRectEdge.None
    
    tweetView = TweetView()
    tweetView.tweet = tweet
    tweetView.replyActionHandler = { (tweetId: String, tweetUserScreenname: String) -> Void in
      
      print("Replying to tweet id: \(tweetId)")
      print("Replying to screenname: \(tweetUserScreenname)")
      let composeViewController = ComposeViewController(inReplyToStatusId: tweetId, inReplyToScreenname: tweetUserScreenname)
      
      self.navigationController?.pushViewController(composeViewController, animated: true)
    }
    tweetView.userProfileShowHandler = { (user: User) -> Void in
      
      let profileViewController = ProfileViewController(user: user)
      
      self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    view.addSubview(tweetView)
    
    setupConstraints()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // NOTE: The tweet view needs to be a subview of the main view so that it gets constrained within the area under the navigation bar.
  // If the tweet view is made into the main view, then it will extend beyond the nav bar and hide behind it.
  func setupConstraints() {
    tweetView.translatesAutoresizingMaskIntoConstraints = false
    
    let views = [
      "tweetView": tweetView,
    ]
    
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tweetView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tweetView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
  }

  func onCancel() {
    navigationController?.popViewControllerAnimated(true)
  }

}
