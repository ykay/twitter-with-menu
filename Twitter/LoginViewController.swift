//
//  LoginViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/1/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.title = "Twitter"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogin(sender: AnyObject) {
    TwitterClient.sharedInstance.login() { (user: User?, error: NSError?) -> Void in
      if user != nil {
        let mainViewController = MainViewController()
        
        let navController = UIApplication.sharedApplication().windows[0].rootViewController as! UINavigationController
        navController.pushViewController(mainViewController, animated: true)
      } else {
        
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
