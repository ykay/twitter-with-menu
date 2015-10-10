//
//  AppDelegate.swift
//  Twitter
//
//  Created by Yuichi Kuroda on 9/30/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

    /*self.window!.rootViewController = MainViewController()
    self.window!.makeKeyAndVisible()*/
    
    let viewController: UIViewController = LoginViewController()
    let navController: UINavigationController = UINavigationController(rootViewController: viewController)
    
    self.window!.rootViewController = navController
    self.window!.makeKeyAndVisible()
    
    navController.navigationItem.title = "Twitter"
    
    let titleDict: [String:AnyObject] = [NSForegroundColorAttributeName: UIColor(red:0.27, green:0.60, blue:0.92, alpha:1.0)]
    navController.navigationBar.titleTextAttributes = titleDict as [String : AnyObject]
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userLogoutNotification, object: nil)

    if User.currentUser != nil {
      // Go to logged in screen
      print("Current user logged in: " + User.currentUser!.name)
      
      let mainViewController: UIViewController = MainViewController()
      navController.pushViewController(mainViewController, animated: true)
    }
    
    return true
  }

  func userDidLogout() {
    print("Notification: User Logged out")
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
    TwitterClient.sharedInstance.openURL(url)
    
    return true
  }


}

