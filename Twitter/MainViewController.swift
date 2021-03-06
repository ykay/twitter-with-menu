//
//  MainViewController.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 10/9/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var menuTableView: UITableView!
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var menuHeaderView: UIView!
  @IBOutlet weak var menuConstraintWidth: NSLayoutConstraint!
  @IBOutlet weak var menuConstraintLeading: NSLayoutConstraint!
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var chevronImageView: UIImageView!
  
  var selectedViewController: UIViewController?
  
  var menuBeginningConstraintLeading: CGFloat!
  var menuOpenedConstraintLeading: CGFloat!
  var menuClosedConstraintLeading: CGFloat!
  
  let chevronAlpha: CGFloat = 0.5
  
  let pageNames = [ "Home", "Profile", "Mentions" ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.selectViewController(HomeViewController())
    
    // Do any additional setup after loading the view.
    navigationItem.title = pageNames[0]
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "onCompose")
    navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: Appearance.colorTwitterWhite], forState: UIControlState.Normal)
    
    let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "onLogout:")
    navigationItem.leftBarButtonItem = logoutButton
    navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: Appearance.colorTwitterWhite], forState: UIControlState.Normal)
    
    navigationController?.navigationBar.barTintColor = Appearance.colorTwitterBlue
    navigationController?.navigationBar.translucent = false
    
    menuOpenedConstraintLeading = 0
    menuClosedConstraintLeading = menuConstraintLeading.constant // about -210
    
    menuTableView.delegate = self
    menuTableView.dataSource = self
    
    menuTableView.registerNib(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
    menuTableView.rowHeight = UITableViewAutomaticDimension
    menuTableView.estimatedRowHeight = 140
    menuTableView.backgroundColor = UIColor.whiteColor()
    
    let menuPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMenuPan:")
    menuPanGestureRecognizer.delegate = self
    menuView.addGestureRecognizer(menuPanGestureRecognizer)
    // Drop shadow
    menuView.layer.masksToBounds = false
    menuViewShadow(false)
    
    profileImageView.setImageWithURL(User.currentUser!.profileImageUrl)
    profileImageView.layer.cornerRadius = 10.0
    profileImageView.layer.masksToBounds = true
    nameLabel.text = User.currentUser!.name
    nameLabel.textColor = Appearance.colorTwitterBlack
    screennameLabel.text = "@" + User.currentUser!.screenname
    screennameLabel.textColor = Appearance.colorTwitterDarkGray
    
    chevronImageView.image = UIImage(named: "chevron-25")
    chevronImageView.alpha = chevronAlpha
    
    containerView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
    containerView.layer.shadowOpacity = 0.3
    containerView.layer.shadowColor = UIColor.darkGrayColor().CGColor
    containerView.layer.shadowRadius = 5.0
    
    // So text box doesn't extend beyond navigation bar
    self.edgesForExtendedLayout = UIRectEdge.None
  }
  
  func menuViewShadow(toggle: Bool) {
    if toggle {
      menuView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
      menuView.layer.shadowOpacity = 0.7
      menuView.layer.shadowColor = UIColor.darkGrayColor().CGColor
      menuView.layer.shadowRadius = 10.0
    } else {
      menuView.layer.shadowRadius = 5.0
      menuView.layer.shadowOpacity = 0.3
    }
  }
  
  func selectViewController(vc: UIViewController) {
    // Remove current view controller
    if let oldViewController = selectedViewController {
      oldViewController.willMoveToParentViewController(nil)
      oldViewController.view.removeFromSuperview()
      oldViewController.removeFromParentViewController()
    }
    
    // Switch to new view controller
    self.addChildViewController(vc)
    vc.view.frame = self.containerView.bounds
    vc.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    self.containerView.addSubview(vc.view)
    vc.didMoveToParentViewController(self)
    selectedViewController = vc
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onCompose() {
    let composeViewController = ComposeViewController()
    
    navigationController?.pushViewController(composeViewController, animated: true)
  }
  
  func onLogout(sender: AnyObject) {
    TwitterClient.sharedInstance.logout()
    
    navigationController?.popViewControllerAnimated(true)
  }
  
  func onMenuPan(sender: UIPanGestureRecognizer) {
    
    switch sender.state {
    case .Began:
      menuBeginningConstraintLeading = menuConstraintLeading.constant
      break
    case .Changed:
      let currentPoint = sender.translationInView(self.view)
      
      if menuConstraintLeading.constant <= 0 {
        menuConstraintLeading.constant = menuBeginningConstraintLeading + currentPoint.x
      }
    
    case .Cancelled:
      // TODO: Handle cancelled
      break
    case .Ended:
      
      if sender.velocityInView(self.view).x > 0 {
        // Moving Right (Opening)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
          self.applyMenuTransforms(true)
          self.view.layoutIfNeeded()
        })
      } else {
        // Moving Left (Closing)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
          self.applyMenuTransforms(false)
          self.view.layoutIfNeeded()
        })
      }
      
    default:
      break
    }
  }
  
  func applyMenuTransforms(opening: Bool) {
    var rotationTransform = CGAffineTransformIdentity;
    
    if opening {
      rotationTransform = CGAffineTransformRotate(rotationTransform, 180.0 * CGFloat(M_PI) / 180.0);
      menuConstraintLeading.constant = self.menuOpenedConstraintLeading
      chevronImageView.alpha = 0.0
    } else {
      rotationTransform = CGAffineTransformRotate(rotationTransform, 0.0 * CGFloat(M_PI) / 180.0);
      menuConstraintLeading.constant = self.menuClosedConstraintLeading
      chevronImageView.alpha = chevronAlpha
    }
    
    chevronImageView.transform = rotationTransform;
    self.menuViewShadow(opening)
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

extension MainViewController: UIGestureRecognizerDelegate {
  
  // Required for menuView to respond to pan gesture
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    
    return true
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
    
    if indexPath.row == 0 {
      cell.iconImageView.image = UIImage(named: "home-25")
    } else if indexPath.row == 1 {
      cell.iconImageView.image = UIImage(named: "twitter-25")
    } else if indexPath.row == 2 {
      cell.iconImageView.image = UIImage(named: "speech_bubble-25")
    }
    
    cell.nameLabel.text = pageNames[indexPath.row]
    cell.nameLabel.textColor = Appearance.colorTwitterBlack
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
    // Switch view
    if indexPath.row == 0 {
      selectViewController(HomeViewController())
    } else if indexPath.row == 1 {
      selectViewController(ProfileViewController(user: User.currentUser!))
    } else if indexPath.row == 2 {
      selectViewController(HomeViewController(mentionsOnly: true))
    }
    
    navigationItem.title = pageNames[indexPath.row]
    
    if menuConstraintLeading.constant == menuOpenedConstraintLeading {
      // Moving Left (Closing)
      UIView.animateWithDuration(1.0, animations: { () -> Void in
        self.applyMenuTransforms(false)
        self.view.layoutIfNeeded()
      })
    }
  }
}