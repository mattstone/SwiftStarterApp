//
//  SSPConfig.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import UIKit

// Singleton - replaced with..global variable as recommended by Apple..

var SSPConfigSharedInstance = SSPConfig()

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

class SSPConfig : NSObject {
    
    static let sharedInstance = SSPConfig()
    
    let ui = SSPUI()
    
    let notifiers = SSPNotifierNames()
    
    // 3rs Pary URLs
    
    
    // Error constants
    // TODO: move to LocalizedStrings
    let CouldNotUnderstandResponseFromServer = "CouldNotUnderstandResponseFromServer"       as String
    let NoConnectionMessage = "There was network problem. Please check your connection."    as String
    let UnknownError        = "An unknown problem was experienced. Please try again later." as String
    
    
    // Network
    var isNetwork : Bool = false
    var isWan     : Bool = false
    var isWiFi    : Bool = false
    
    // Application stuff..
    var hostName     = "" as String
    var baseUrl      = "" as String
    var whoAmI       = "Swift Starter Project" as String
    
    // TODO: move to class
    let awsKey       = ""  as String
    let aesKey       = ""
    let aesiv        = ""
    
    var requestPort  = 0
    var socketIOHost = "" as String
    var socketIOPort = 0
    
    var archivedDictionary = Dictionary<String, AnyObject>()
    var userDictionary     = Dictionary<String, AnyObject>()
    
    var nc                 = NotificationCenter.default
    let device             : Device = Device()
    
    let appDel                          = UIApplication.shared.delegate as? AppDelegate
    
    
    // App setup
    var isTest           : Bool = false
    let isProduction     : Bool = true
    let isSandboxTesting : Bool = true
    
    
    #if DEBUG
    let isBeta         : Bool = true
    #else
    let isBeta         : Bool = false
    #endif
    
    
    // Tests
    var testStatus  = 0
    var testsTotal  = 0
    var testsPassed = 0
    var testsFailed = 0
    
    fileprivate override init()  {
        super.init()
        
        #if DEBUG
            switch isProduction {
            case true:  setupForProduction()
            case false: setupForDevelopment()
            }
        #else
            setupForProduction()
        #endif
        
        baseUrl = "\(baseUrl):\(requestPort)"
    }
    
    
    func setupForDevelopment() {
        hostName     = ""
        baseUrl      = "https://\(hostName)"
        requestPort  = 443
    }
    
    func setupForProduction() {
        hostName     = ""
        baseUrl      = "https://\(hostName)"
        requestPort  = 443
    }
    
    // *** Start archive directory
    
    func fileDocumentDirURL(fileName: String) -> URL {
        let manager = FileManager.default
        let dirURL: NSURL?
        do {
            dirURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL?
        } catch _ {
            dirURL = nil
        }
        return dirURL!.appendingPathComponent(fileName)!
    }
    
    
    func getDeviceToken() -> String {
        let defaults = UserDefaults.standard
        
        switch defaults.string(forKey: "com.tradesamurai.deviceToken") {
        case nil: return ""
        default:  return defaults.string(forKey: "com.tradesamurai.deviceToken")!
        }
    }
    
    func setDeviceToken(deviceToken : String) {
        let defaults       = UserDefaults.standard
        defaults.set(deviceToken, forKey: "com.tradesamurai.deviceToken")
    }
    
    
    func isUserRegisteredForNotifications() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    func registeredUserNotifications() {
        let settings = UIApplication.shared.currentUserNotificationSettings
        NSLog("settings: \(String(describing: settings)) ")
        NSLog("settings.type: \(settings!.types)")
    }
    
}
