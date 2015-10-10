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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    nameLabel.text = User.currentUser!.name
    screennameLabel.text = "@" + User.currentUser!.screenname
    tweetsCountLabel.text = "\(User.currentUser!.tweetsCount)"
    followersCountLabel.text = "\(User.currentUser!.followersCount)"
    followingCountLabel.text = "\(User.currentUser!.followingCount)"
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
