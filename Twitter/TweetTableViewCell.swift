//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var profileThumbImageView: UIImageView!
  
  var tweet: Tweet! {
    didSet {
      nameLabel.text = tweet.user!.name
      screennameLabel.text = "@\(tweet.user!.screenname)"
      tweetTextLabel.text = tweet.text
      dateLabel.text = tweet.createdAt?.description
      profileThumbImageView.setImageWithURL(tweet.user!.profileImageUrl)
      /*profileThumbImageView.setImageWithURLRequest(NSURLRequest(URL: tweet.user!.profileImageUrl!), placeholderImage: nil,
        success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
          let retrievedImage = image
          UIView.transitionWithView(self.profileThumbImageView, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { () -> Void in
              self.profileThumbImageView.image = retrievedImage
            },
            completion: nil)
          
        },
        failure: { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
          
        })*/
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
    profileThumbImageView.layer.cornerRadius = 10.0
    profileThumbImageView.clipsToBounds = true

  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
