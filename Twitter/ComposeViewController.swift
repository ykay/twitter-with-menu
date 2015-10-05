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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.title = "What's happening?"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "onTweet")
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
    
    // So text box doesn't extend beyond navigation bar
    self.edgesForExtendedLayout = UIRectEdge.None
    
    tweetTextView.delegate = self
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
    
    if textView.text.characters.count >= 140 {
      return false
    }
    return true
  }
  
  func textViewDidChange(textView: UITextView) {
    if textView == tweetTextView {
      tweetCounterLabel.text = "\(140 - textView.text.characters.count)"
    }
  }
  
  func onTweet() {
    TwitterClient.sharedInstance.tweet(tweetTextView.text) { (data: [String:AnyObject]?, error: NSError?) -> Void in
      
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
