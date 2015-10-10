//
//  HomeViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/3/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var menuConstraintWidth: NSLayoutConstraint!
  @IBOutlet weak var menuTableView: UITableView!
  
  var tweets = [Tweet]()
  var refreshControl: UIRefreshControl!
  var needsRefresh = false
  
  var menuBeginningConstraintWidth: CGFloat!
  var menuOpenedConstraintWidth: CGFloat!
  var menuClosedConstraintWidth: CGFloat!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let user = User.currentUser {
      navigationItem.title = "@" + user.screenname
    }
    
    menuOpenedConstraintWidth = 320.0
    menuClosedConstraintWidth = menuConstraintWidth.constant // about 15
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "onCompose")
    
    tableView.delegate = self
    tableView.dataSource = self
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    // Do any additional setup after loading the view.
    tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    
    menuTableView.delegate = self
    menuTableView.dataSource = self
    
    menuTableView.registerNib(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
    menuTableView.rowHeight = UITableViewAutomaticDimension
    menuTableView.estimatedRowHeight = 140
    
    menuTableView.backgroundColor = UIColor.lightGrayColor()
    
    let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "onLogout:")
    navigationItem.leftBarButtonItem = logoutButton
    
    let menuPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMenuPan:")
    menuView.addGestureRecognizer(menuPanGestureRecognizer)
    
    // So text box doesn't extend beyond navigation bar
    self.edgesForExtendedLayout = UIRectEdge.None
    
    fetchTweets()
  }
  
  override func viewWillAppear(animated: Bool) {
    if needsRefresh {
      fetchTweets()
    }
    
    needsRefresh = false
  }
  
  func fetchTweets() {
    // TODO: Pass parameters
    TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets: [Tweet]?, error: NSError?) -> Void in
      if error == nil {
        
        self.tweets = tweets!
        self.tableView.reloadData()
        
        for tweet in tweets! {
          //print(tweet.rawDictionary!)
        }
        
      } else {
        print("Failed to get tweet data")
      }
    }
  }

  func onRefresh() {
    fetchTweets()
    
    refreshControl.endRefreshing()
  }

  func onCompose() {
    let composeViewController = ComposeViewController()
    
    navigationController?.pushViewController(composeViewController, animated: true)
  }
  
  func onReplyTap(sender: AnyObject!) {
    let tweetTap = sender as! TweetTapGestureRecognizer
    
    print("Replying to tweet id: \(tweetTap.id)")
    print("Replying to screenname: \(tweetTap.screenname)")
    let composeViewController = ComposeViewController(inReplyToStatusId: tweetTap.id, inReplyToScreenname: tweetTap.screenname)
    
    navigationController?.pushViewController(composeViewController, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onLogout(sender: AnyObject) {
    TwitterClient.sharedInstance.logout()
    
    navigationController?.popViewControllerAnimated(true)
  }
  
  func onMenuPan(sender: UIPanGestureRecognizer) {
    
    switch sender.state {
    case .Began:
      menuBeginningConstraintWidth = menuConstraintWidth.constant
      break
    case .Changed:
      let currentPoint = sender.translationInView(self.view)
      
      menuConstraintWidth.constant = menuBeginningConstraintWidth + currentPoint.x
    case .Cancelled:
      // TODO: Handle cancelled
      break
    case .Ended:
      
      if sender.velocityInView(self.view).x > 0 {
        // Moving Right
        UIView.animateWithDuration(0.5, animations: { () -> Void in
          self.menuConstraintWidth.constant = self.menuOpenedConstraintWidth
          self.view.layoutIfNeeded()
        })
      } else {
        // Moving Left
        UIView.animateWithDuration(0.5, animations: { () -> Void in
          self.menuConstraintWidth.constant = self.menuClosedConstraintWidth
          self.view.layoutIfNeeded()
        })
      }
      
    default:
      break
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.menuTableView {
      return 3
    } else {
      return tweets.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if tableView == self.menuTableView {
      let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
      
      cell.nameLabel.text = "Home \(indexPath.row)"
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
      
      cell.tweet = tweets[indexPath.row]
      
      let replyTap = TweetTapGestureRecognizer(target: self, action: "onReplyTap:")
      replyTap.numberOfTapsRequired = 1
      replyTap.id = tweets[indexPath.row].id
      replyTap.screenname = tweets[indexPath.row].user!.screenname
      
      // Add tap handler for cell here, since we need to push a view controller from here.
      cell.replyImageView.userInteractionEnabled = true
      cell.replyImageView.addGestureRecognizer(replyTap)
      
      return cell
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
    if tableView == menuTableView {
      // Switch view
    } else {
      let tweetDetailsViewController = TweetDetailsViewController()
      tweetDetailsViewController.tweet = tweets[indexPath.row]
      navigationController?.pushViewController(tweetDetailsViewController, animated: true)
    }
  }
}