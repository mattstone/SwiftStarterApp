//
//  AppDelegate.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

enum SSPPreferredOrientation {
    case landscape
    case portrait
    case any
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let config           = SSPConfig.sharedInstance
    let includes         = SSPIncludes.sharedInstance
    
    var orientation  : SSPPreferredOrientation = .portrait
    var shouldRotate : Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        Uncomment once configure for Firebase
//        FirebaseApp.configure() // get Firebase underway
        
        UNUserNotificationCenter.current().delegate = self

        setupObservers()
        return true
    }

    // If application opened by URL
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        
        
        // Extract custom params..
        
        let urlComponents  = NSURLComponents(string: url.absoluteString)
        let queryItems     = urlComponents?.queryItems
        let channel        = queryItems?.filter({$0.name == "channel"}).first
        let campaign       = queryItems?.filter({$0.name == "campaign"}).first
        
        var channelString  = "\(String(describing: channel))"
        var campaignString = "\(String(describing: campaign))"
        if channelString  == "Optional(nil)" { channelString  = "" }
        if campaignString == "Optional(nil)" { campaignString = "" }
        
        // TODO: Do something with channelString & campaignString
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Custom functions
    
    // Observers
    
    private func setupObservers() {
        
    }
    
    
    // Orientation
    
    func isDeviceLandscape() -> Bool { return UIDevice.current.orientation.isLandscape }
    func isDevicePortrait()  -> Bool { return UIDevice.current.orientation.isPortrait  }
    
    func setPeferredOrientation(orientation : SSPPreferredOrientation) {
        
        self.orientation = orientation
        
        var value : Int = 0
        
        switch orientation {
        case .portrait:  value = UIInterfaceOrientation.portrait.rawValue
        case .landscape: value = UIInterfaceOrientation.landscapeLeft.rawValue
        case .any:       value = UIInterfaceOrientation.unknown.rawValue
        }
        
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        switch orientation {
        case .portrait:  return .portrait
        case .landscape: return .landscape
        case .any:       return .allButUpsideDown
        }
    }


}

