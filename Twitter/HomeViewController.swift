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
  
  var tweets = [Tweet]()
  var refreshControl: UIRefreshControl!
  var needsRefresh = false  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    
    // Do any additional setup after loading the view.
    tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    
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
    return tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
    let tweetDetailsViewController = TweetDetailsViewController()
    tweetDetailsViewController.tweet = tweets[indexPath.row]
    navigationController?.pushViewController(tweetDetailsViewController, animated: true)
  }
}