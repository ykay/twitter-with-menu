//
//  HomeViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/3/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "onLogout:")
    navigationItem.leftBarButtonItem = logoutButton
    
    // TODO: Pass parameters
    TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets: [Tweet]?, error: NSError?) -> Void in
      if error == nil {
        for tweet in tweets! {
          print("Tweet: " + tweet.text)
        
        }
      } else {
        print("Failed to get tweet data")
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onLogout(sender: AnyObject) {
    TwitterClient.sharedInstance.logout()
    
    navigationController?.popViewControllerAnimated(true)
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
