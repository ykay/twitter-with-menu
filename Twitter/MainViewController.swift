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
  @IBOutlet weak var menuConstraintHorizontal: NSLayoutConstraint!
  
  var selectedViewController: UIViewController?
  
  var viewControllers: [UIViewController] = [
    HomeViewController(),
    ProfileViewController(),
  ]
  
  var menuBeginningConstraintHorizontal: CGFloat!
  var menuOpenedConstraintHorizontal: CGFloat!
  var menuClosedConstraintHorizontal: CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.selectViewController(viewControllers[0])
    
    // Do any additional setup after loading the view.
    if let user = User.currentUser {
      navigationItem.title = "@" + user.screenname
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "onCompose")
    
    let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "onLogout:")
    navigationItem.leftBarButtonItem = logoutButton
    
    menuOpenedConstraintHorizontal = -80.0
    menuClosedConstraintHorizontal = menuConstraintHorizontal.constant // about -350
    
    menuTableView.delegate = self
    menuTableView.dataSource = self
    
    menuTableView.registerNib(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
    menuTableView.rowHeight = UITableViewAutomaticDimension
    menuTableView.estimatedRowHeight = 140
    
    menuTableView.backgroundColor = UIColor.lightGrayColor()
    
    let menuPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMenuPan:")
    menuPanGestureRecognizer.delegate = self
    menuView.addGestureRecognizer(menuPanGestureRecognizer)
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
      menuBeginningConstraintHorizontal = menuConstraintHorizontal.constant
      break
    case .Changed:
      let currentPoint = sender.translationInView(self.view)
      
      menuConstraintHorizontal.constant = menuBeginningConstraintHorizontal + currentPoint.x
    case .Cancelled:
      // TODO: Handle cancelled
      break
    case .Ended:
      
      if sender.velocityInView(self.view).x > 0 {
        // Moving Right
        UIView.animateWithDuration(0.5, animations: { () -> Void in
          self.menuConstraintHorizontal.constant = self.menuOpenedConstraintHorizontal
          self.view.layoutIfNeeded()
        })
      } else {
        // Moving Left
        UIView.animateWithDuration(0.5, animations: { () -> Void in
          self.menuConstraintHorizontal.constant = self.menuClosedConstraintHorizontal
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

extension MainViewController: UIGestureRecognizerDelegate {
  
  // Required for menuView to respond to pan gesture
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    
    return true
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
      
      cell.nameLabel.text = "Home \(indexPath.row)"
      
      return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)

    // Switch view
    selectViewController(viewControllers[indexPath.row])

    if menuConstraintHorizontal.constant == menuOpenedConstraintHorizontal {
      // Moving Left
      UIView.animateWithDuration(1.0, animations: { () -> Void in
        self.menuConstraintHorizontal.constant = self.menuClosedConstraintHorizontal
        self.view.layoutIfNeeded()
      })
    }

  }
}