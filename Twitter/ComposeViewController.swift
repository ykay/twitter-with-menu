//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var tweetCounterLabel: UILabel!
  
  private let maximumTweetLength = 140
  
  var inReplyToStatusId: String?
  var inReplyToScreenname: String?
  
  convenience init(inReplyToStatusId: String, inReplyToScreenname: String) {
    self.init()
    
    self.inReplyToStatusId = inReplyToStatusId
    self.inReplyToScreenname = inReplyToScreenname
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.title = "What's happening?"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "onTweet")
    navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: Appearance.colorTwitterWhite], forState: UIControlState.Normal)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: Appearance.colorTwitterWhite], forState: UIControlState.Normal)
    
    // So text box doesn't extend beyond navigation bar
    self.edgesForExtendedLayout = UIRectEdge.None
    
    tweetTextView.delegate = self
    
    if let screenname = inReplyToScreenname {
      tweetTextView.text = "@\(screenname) "
      tweetCounterLabel.text = "\(maximumTweetLength - tweetTextView.text.characters.count)"
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    // If key is a backspace, allow it.
    if text == "" {
      return true;
    }
    
    if textView.text.characters.count >= maximumTweetLength {
      return false
    }
    return true
  }
  
  func textViewDidChange(textView: UITextView) {
    if textView == tweetTextView {
      tweetCounterLabel.text = "\(maximumTweetLength - textView.text.characters.count)"
    }
  }
  
  func onTweet() {
    TwitterClient.sharedInstance.tweet(tweetTextView.text, inReplyToStatusId: inReplyToStatusId) { (data: [String:AnyObject]?, error: NSError?) -> Void in
      
      if error == nil {
        
        if let count = self.navigationController?.viewControllers.count {
          if let homeViewController = self.navigationController?.viewControllers[count-2] as? HomeViewController {
            homeViewController.needsRefresh = true
          }
        }
        self.navigationController?.popViewControllerAnimated(true)
      } else {
        
      }
    }
  }
  
  func onCancel() {
    self.navigationController?.popViewControllerAnimated(true)
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
