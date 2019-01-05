//
//  SSPIncludes.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import SVProgressHUD
import SystemConfiguration
import UserNotifications

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable     = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}



var SSPIncludesSharedInstance = SSPIncludes()

class SSPIncludes : NSObject {

    static let sharedInstance = SSPIncludes()
    
    enum SizeClass {
        case undefined
        case compact
        case regular
        case plus
    }
    
    let config           = SSPConfig.sharedInstance
    let onDemandResource = SSPOnDemandContent.sharedInstance
    
    var progressHUDStatus = "" as String
    var timers            = [(name: String, startTime: TimeInterval, object: Any?)]()
    var isTimersOn : Bool = false
    
    // Start - User progress  TODO: move to user model
    
    fileprivate override init() {
        super.init()
    }
    
    // Useage:  let encryptedString = includes.aesEncrypt("This is the text to encrypt")
    func aesEncrypt(_ string: String) -> String {
        let cryptoLib = CryptLib()
        switch string == "" {
        case true:  return ""
        case false: return cryptoLib.encryptPlainText(with: string, key: config.aesKey, iv: config.aesiv)
        }
    }
    
    func errorAlert(message: String) -> UIAlertController {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return ac
    }
    
    func resetPushNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // Network connectivity
    
    func setNetworkOff() {
        config.isNetwork = false
        config.isWiFi    = false
        config.isWan     = false
        config.nc.post(name: NSNotification.Name(rawValue: config.notifiers.SSP_NETWORK_OFF), object: nil)
        
    }
    
    func setNetworkWifi() {
        config.isNetwork = true
        config.isWiFi    = true
        config.isWan     = false
        config.nc.post(name: NSNotification.Name(rawValue: config.notifiers.SSP_NETWORK_WIFI), object: nil)
    }
    
    func setNetworkWan() {
        setNetworkOff()
        config.isNetwork = true
        config.isWiFi    = false
        config.isWan     = true
        config.nc.post(name: NSNotification.Name(rawValue: config.notifiers.SSP_NETWORK_WAN), object: nil)
    }
    
    func delay( _ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    // Keychain
    
    func isLoginKey() -> Bool { return UserDefaults.standard.bool(forKey: "hasLoginKey") }
    
    func initialiseLoginKey(email : String) {
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if !hasLoginKey && !email.isEmpty {
            UserDefaults.standard.setValue(email, forKey: "email")
        }
    }
    
    func setLoginKey() { UserDefaults.standard.set(true, forKey: "hasLoginKey") }
    
    
    // UI View
    func isHorizontalSizeClassRegular(view : UIView) -> Bool {
        switch view.traitCollection.horizontalSizeClass {
        case .compact:     return false
        case .regular:     return true
        case .unspecified: return false
        }
    }
    
    // Progress HUD
    
    func showProgressHUD(/*view : UIView,*/ title : String = "Loading")  {
        
        if progressHUDStatus != title {
            progressHUDStatus = title
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: title)
                SVProgressHUD.setDefaultAnimationType(.flat)
            }
        }
    }
    
    func isProgressHUDVisible() -> Bool { return SVProgressHUD.isVisible() }
    
    func updateProgressHUDLabel(label   : String) {
        progressHUDStatus = label
        //        DispatchQueue.main.async {
        //            SVProgressHUD.setStatus(label)
        //        }
    }
    
    func updateProgressHUDDetail(detail : String) {
        progressHUDStatus = progressHUDStatus + "\n" + detail
        DispatchQueue.main.async(execute: { SVProgressHUD.setStatus(detail) })
    }
    
    func hideProgressHUD() {
        DispatchQueue.main.async { SVProgressHUD.dismiss() }
        progressHUDStatus = ""
    }

    // Background Queue
    func backgroundQueue() -> DispatchQueue {
        //let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        return DispatchQueue.global(qos: .background)
    }
    
    // General stuff
    func urlEncode(string : String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func urlEncodeFormat2(string : String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }

    // TODO: move to string extension
    func trimWhiteSpace(string: String) -> String {
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func removeWhiteSpaces(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    func stringWithOnlyNumber(string: String) -> String {
        var result : String = "" as String
        
        for char in string.unicodeScalars {
            if char >= "0" && char <= "9" { result = "\(result)\(char)" }
        }
        return result
    }
    
    func doubleFromAnyObject(anyObject : AnyObject) -> Double {
        var double = 0.00 as Double
        
        if let s = anyObject as? NSString {
            double = s.doubleValue
        } else if let f = anyObject as? Float {
            double = Double(f)
        }
        
        return double
    }
    
    func stringFromAnyObject(anyObject : AnyObject) -> String {
        var string = ""
        if let s = anyObject as? String { string = s }
        return string
    }
    
    func validateEmail(emailAddress: String) -> Bool {
        if emailAddress == "" { return false }
        
        let emailRegex =
        "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: emailAddress)
    }
    
    func displayPrice(price : NSDecimalNumber, symbol : String) -> String {
        switch symbol.range(of: "JPY") != nil {
        case true: return price.rounding(accordingToBehavior: decimalNumberHandler(decimalPoints: 3)).stringValue
        default:   return price.rounding(accordingToBehavior: decimalNumberHandler(decimalPoints: 6)).stringValue
        }
    }
    
    func getTwoNSDecimalPlaces(value : NSDecimalNumber) -> String {
        return value.rounding(accordingToBehavior: decimalNumberHandler(decimalPoints: 2)).stringValue
    }
    
    func getZeroNSDecimalPlaces(value : NSDecimalNumber) -> String {
        return value.rounding(accordingToBehavior: decimalNumberHandler(decimalPoints: 0)).stringValue
    }
    
    func getDollarFormat(value : NSDecimalNumber) -> String {
        let roundedValue = getTwoNSDecimalPlaces(value: value)
        return "$\(roundedValue)"
    }
    
    func getYenFormat(value : NSDecimalNumber) -> String {
        let roundedValue = getZeroNSDecimalPlaces(value: value)
        return "$\(roundedValue)"
    }
    
    func decimalNumberHandler(decimalPoints : Int16) -> NSDecimalNumberHandler {
        return NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: decimalPoints,
            raiseOnExactness:    false,
            raiseOnOverflow:     false,
            raiseOnUnderflow:    false,
            raiseOnDivideByZero: false
        )
    }
    
    func randomString(length: NSNumber) -> String {
        let alphabet  = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789" as String
        
        var s = ""
        
        for _ in 0..<length.intValue {
            let rand = Int(arc4random_uniform(62))
            var j = 0
            for character in alphabet {
                j += 1
                if j == rand { s = "\(s)\(character)" }
            }
        }
        return s
    }
    
    // logout
    
    func logout() {
    }
    
    // Time
    
    func numDaysInCurrentMonth() -> Int {
        let date     = Date()
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
        
    }
    
    func numDaysInCurrentYear() -> Int {
        let date     = Date()
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .year, for: date)!
        return range.count
    }
    
    // Date
    
    func dateToIso8601(date : Date) -> String {
        let formatter        = DateFormatter()
        formatter.calendar   = Calendar(identifier: .iso8601)
        formatter.locale     = Locale(identifier: "en_US_POSIX")
        formatter.timeZone   = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter.string(from: date)
    }
    
    func dateStringToUTC(string : String) -> NSDate {
        let dateFormater : DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy:MM:dd-HH:mm:ss"      // date is in this format
        let date : NSDate? = dateFormater.date(from: string) as NSDate?
        return dateToUTC(date: date!)
    }
    
    func igUpdateTimeToNSDate(timeString : String) -> NSDate {
        //let date = NSDate()
        let utcFormatter        = DateFormatter()
        utcFormatter.timeZone   = NSTimeZone(abbreviation: "BST") as TimeZone?
        utcFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let timeString = "\(timeString) UTC"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss z"
        return dateFormatter.date(from: timeString)! as NSDate
    }
    
    
    func igDateToNSDate(dateString: String) -> (NSDate) {
        let dateString = "\(dateString) UTC"                   // IG dates always UTC
        let dateFormater : DateFormatter = DateFormatter()
        
        switch dateString.range(of: "/") != nil {
        case true:  dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss z"
        case false: dateFormater.dateFormat = "yyyy:MM:dd-HH:mm:ss z"
        }
        return dateFormater.date(from: dateString)! as (NSDate)
    }
    
    func dateAsString(date : NSDate) -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.timeZone   = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss z"
        return dateFormatter.string(from: date as Date)
    }
    
    func dateAsStringNoSpaces(date : Date) -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.timeZone   = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "yyyyMMdd-E-HH-mm-ss-SSS"
        return dateFormatter.string(from: date as Date)
    }
    
    func dateFromStringIG(string : String) -> NSDate {
        let dateFormater : DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy:MM:dd-HH:mm:ss"      // date is in this format
        return dateFormater.date(from: string)! as NSDate
    }
    
    func dateFromMongoISODate(date : String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  // Date is in this format
        return formatter.date(from: date)!
    }
    
    func dateToMongoISODate(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  // Date is in this format
        return formatter.string(from: date)
    }
    
    func dateNowGMT() -> NSDate { return dateToUTC(date: NSDate()) }
    
    func dateToUTC(date : NSDate) -> NSDate {
        let timeZoneOffset  : Int = NSTimeZone.default.secondsFromGMT()
        let foo             : Double = round(date.timeIntervalSinceReferenceDate)
        let gmtTimeInterval : Double = foo - Double(timeZoneOffset)
        return NSDate(timeIntervalSinceReferenceDate: gmtTimeInterval)
    }
    
    func dateFromUTS(timeInterval : TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    // Date comparison
    
    func isDateInFuture(date : NSDate) -> Bool {
        return NSDate().compare(date as Date) == ComparisonResult.orderedAscending
    }
    
    func isDateInPast(date : NSDate) -> Bool {
        return NSDate().compare(date as Date) == ComparisonResult.orderedDescending
    }

    
    // Display prices
    
    func displayFXPrice(currencyCode : String, amount : Double) -> String {
        let numberFormatter = standardDecimalNumberFormatter(fractionalDigits: 5)
        
        switch currencyCode.lowercased().range(of: "jpy") != nil {
        case true:
            numberFormatter.minimumFractionDigits = 3
            numberFormatter.maximumFractionDigits = 3
        default: break
        }
        
        //return numberFormatter.string(from: NSNumber(amount))!
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func displayNumber2DecimalPlaces(double : Double) -> String {
        let numberFormatter = standardDecimalNumberFormatter(fractionalDigits: 2)
        return numberFormatter.string(from: NSNumber(value: double))!
    }
    
    // Decimal number
    
    func standardDecimalNumberFormatter(fractionalDigits : Int = 5) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle                 = .decimal
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.usesSignificantDigits       = false
        numberFormatter.minimumFractionDigits       = fractionalDigits
        numberFormatter.maximumFractionDigits       = fractionalDigits
        
        switch fractionalDigits {
        case 0: numberFormatter.roundingIncrement   = 0       as NSNumber
        case 1: numberFormatter.roundingIncrement   = 0.1     as NSNumber
        case 2: numberFormatter.roundingIncrement   = 0.01    as NSNumber
        case 3: numberFormatter.roundingIncrement   = 0.001   as NSNumber
        case 4: numberFormatter.roundingIncrement   = 0.0001  as NSNumber
        case 5: numberFormatter.roundingIncrement   = 0.00001 as NSNumber
        default: break
        }
        
        return numberFormatter
    }
    
    
    // UIView - TODO: move to extension
    // When user taps on a view, quickly flash white so user can tell that they have tapped on it.
    func popView(view : UIView, endColour: UIColor) {
        view.backgroundColor = UIColor.white
        view.alpha           = 0.7
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            view.backgroundColor = endColour
            view.alpha           = 1.0
        }
    }
    
    
    // Colour -- TODO move to UIColor extension..
    
    func hexToUIColor(hexCode : String) -> UIColor {
        var colour = UIColor.white
        
        var characterSet = NSMutableCharacterSet.whitespacesAndNewlines
        characterSet.formUnion(NSCharacterSet(charactersIn: "#") as CharacterSet)
        
        //        let cString = hexCode.stringByTrimmingCharactersInSet(characterSet).uppercaseString
        
        let cString = hexCode.trimmingCharacters(in: characterSet)
        
        
        if (cString.count == 6) {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            colour = UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                             green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                             blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                             alpha: CGFloat(1.0))
        }
        
        return colour
    }
    
    // screen shot
    func screenShot() -> UIImage {
        let window: UIWindow! = UIApplication.shared.keyWindow
        UIGraphicsBeginImageContextWithOptions(window.frame.size, window.isOpaque, UIScreen.main.scale)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // Notifications
    
    // Callbacks in AppDelegate.swift
    // Success = didRegisterForRemoteNotificationsWithDeviceToken
    // Fail    = didFailToRegisterForRemoteNotificationsWithError
    func registerUserNotifications(vc: UIViewController, function: @escaping () -> ()) {
        
        let alert = UIAlertController(title: "💡Tip", message: "Please allow sending of Notifications", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
                }
                function()
            }
        }))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
            self.hideProgressHUD()
        }
    }
    
        func unregisterForRemoteNotifications() {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    
    /// Schedules notifications for the app.
    ///
    /// - parameter title:              Title/Header for notification as seen on device.
    /// - parameter message:            The message body for notification.
    /// - parameter intervalInSeconds:  The interval in seconds from *now* until notification time.
    /// - parameter badgeNumber:        The number displayed on the red circle over the app icon.
    /// - parameter userInfo:           Pass in user information to the notification. i.e. `isMarketing`
    /// - parameter category:           The category of the the notification, used for identification.
    ///
    
    func scheduleLocalNotification(title: String, message: String, intervalInSeconds: TimeInterval, badgeNumber: Int = 0, userInfo: Dictionary<AnyHashable, Any> = Dictionary<AnyHashable, Any>(), category: String = "Default") {
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = category
        content.title = title
        content.body  = message
        content.badge = badgeNumber as NSNumber?
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "samuraiSwordClick.wav"))
        content.launchImageName = "Default.png"
        content.userInfo = userInfo
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalInSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: timeTrigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Do something with error
                print("ERROR SCHEDULING NOTIFICATION WITH ID: \(request.identifier): \(error)")
            } else {
                // Request was added successfully
            }
        }
    }
    
    // Used to track the time of notifications
    // Uncomment prints to use
    func addTimer(name: String, object: Any! = nil) {
        if isTimersOn {
            print("Timer Init:  ~\(name)~")
        }
        timers.append((name, Date().timeIntervalSince1970, object))
    }
    
    func showTimerDuration(name: String, object: Any! = nil) {
        var removeInt : Int!
        for (index, timer) in timers.enumerated() {
            if object != nil, timer.object != nil {
                if (timer.object as AnyObject).description == (object as AnyObject).description {
                    if isTimersOn {
                        print("Timer Name:      *\(timer.name)*")
                        print("Timer Time:      *\(Date().timeIntervalSince1970 - timer.startTime)")
                        print("Timer Object:    *\(String(describing: (timer.object as AnyObject).description))")
                    }
                    removeInt = index
                    break
                }
            } else {
                if timer.name == name {
                    if isTimersOn {
                        print("Timer Name:      *\(timer.name)*")
                        print("Timer Time:      *\(Date().timeIntervalSince1970 - timer.startTime)*")
                    }
                    removeInt = index
                    break
                }
            }
        }
        if removeInt != nil { timers.remove(at: removeInt) }
    }
    
    /// Should be used inside a view's class
    func removeConstraint(in view: UIView, for firstItem: UIView, attributeType: NSLayoutConstraint.Attribute, secondItem: UIView! = nil) {
        //                        print("#### removing constraint")
        for constraint in view.constraints {
            if constraint.firstItem as? UIView == firstItem {
                if constraint.secondItem as? UIView == secondItem {
                    if constraint.firstAttribute == attributeType {
                        view.removeConstraint(constraint)
                        //                        print("**** **** removed")
                        //                        print(constraint)
                        //                    print("********************  \(attributeType.rawValue) Contstraint  ********************")
                    }
                }
                else if secondItem == nil {
                    if constraint.firstAttribute == attributeType {
                        view.removeConstraint(constraint)
                        //                        print("**** removed")
                        //                        print(constraint)
                    }
                }
            }
            else if constraint.secondItem as? UIView == firstItem {
                //                                print("as second Item")
                //                                print(constraint)
                //                                print("----")
            }
        }
        //                        print("#### constraint removed")
    }
    
    func sizeClass(_ view: UIView) -> SizeClass {
        if isCompactSizeClass(view) {
            return .compact
        } else if isRegularSizeClass(view) {
            return .regular
        } else if isPlusSizeClass(view) {
            return .plus
        } else {
            return .undefined
        }
    }
    
    func isCompactSizeClass(_ view: UIView) -> Bool {
        return view.traitCollection.horizontalSizeClass == .compact && view.traitCollection.verticalSizeClass == .compact
    }
    
    func isPlusSizeClass(_ view: UIView) -> Bool {
        return view.traitCollection.horizontalSizeClass == .regular && view.traitCollection.verticalSizeClass == .compact
    }
    
    func isRegularSizeClass(_ view: UIView) -> Bool {
        return view.traitCollection.horizontalSizeClass == .regular && view.traitCollection.verticalSizeClass == .regular
    }
    
    func getFirstResponder(in view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder { return subView }
        }
        return nil
    }
    
    func resetRemoteNotificationsBadgeCount() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func isRemoteNotifications() -> Bool {
        //        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        //        return notificationType != UIUserNotificationType.none
        
        guard let types = UIApplication.shared.currentUserNotificationSettings?.types else {
            return false
        }
        
        switch types {
        case []: return false
        default: return true
            
            //        case [.alert]: break
            //        case [.alert, .badge]: break
            //        case [.alert, .badge, .sound]: break
        }
    }
    
    func currencySymbol(string: String) -> String {
        //        print("THE CURRENCY SYMBOL IS: \(string)")
        
        switch string {
        case "JPY": return "¥"
        case "CAD": return "CD"
        case "USD": return "$"
        case "CHF": return "SF"
        case "NZD": return "NZ"
        case "AUD": return "A$"
        case "GBP": return "£"
        case "SGD": return "SD"
        case "EUR": return "€"
        case "CNH": return "CNH"
        default: return "$"
        }
    }
    
    func convertDeviceTokenToString(deviceToken: Data) -> String {
        return deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    }
    
    // Animations
    
    func wiggleRandomise(interval: TimeInterval, withVariance variance: Double) -> Double{
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
    
    func wiggleStart(for view: UIView) {
        
        let wiggleBounceY                = 4.0
        let wiggleBounceDuration         = 0.12
        let wiggleBounceDurationVariance = 0.025
        
        let wiggleRotateAngle            = 0.06
        let wiggleRotateDuration         = 0.10
        let wiggleRotateDurationVariance = 0.025
        
        //Create rotation animation
        let rotationAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnim.values       = [-wiggleRotateAngle, wiggleRotateAngle]
        rotationAnim.autoreverses = true
        rotationAnim.duration     = wiggleRandomise(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
        rotationAnim.repeatCount  = HUGE
        
        //Create bounce animation
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceAnimation.values       = [wiggleBounceY, 0]
        bounceAnimation.autoreverses = true
        bounceAnimation.duration     = wiggleRandomise(interval: wiggleBounceDuration, withVariance: wiggleBounceDurationVariance)
        bounceAnimation.repeatCount  = HUGE
        
        //Apply animations to view
        UIView.animate(withDuration: 0) {
            view.layer.add(rotationAnim, forKey: "rotation")
            view.layer.add(bounceAnimation, forKey: "bounce")
            view.transform = .identity
        }
    }
    
    func wiggleStop(for view: UIView) { view.layer.removeAllAnimations() }
    
    
    // Test routines
    
    #if DEBUG
    func startTest (name : String) {
        NSLog("-------------------------------------------------------")
        NSLog("\(name) - Start Tests")
        NSLog("-------------------------------------------------------")
    }
    
    func finishedTest(name: String) {
        NSLog("-------------------------------------------------------")
        NSLog("\(name) - Finished Tests")
        NSLog("-------------------------------------------------------")
    }
    
    func finishedTests() {
        NSLog("=======================================================")
        NSLog("Finished Testing")
        NSLog("    Total Tests: \(config.testsTotal)")
        NSLog("    👍: \(config.testsPassed)")
        NSLog("    ❌: \(config.testsFailed)")
        NSLog("=======================================================")
        
    }
    
    func logNormal(text: String) {
        config.testsTotal  += 1
        config.testsPassed += 1
        NSLog("👍: \(config.testsPassed): \(text)")
    }
    
    func logError(text:  String) {
        config.testsTotal  += 1
        config.testsFailed += 1
        NSLog("❌: \(config.testsFailed): \(text)")
    }
    #endif
    
    
    func fetchImage(urlString: String) -> UIImage! {
        
        guard let url = URL(string: urlString) else {
            print("FETCH IMAGE FAILURE: COULD NOT CAST URL: \(urlString)")
            return nil
        }
        
        var filePath = url.path
        
        filePath = filePath.replacingOccurrences(of: "/images", with: "tsImages")
        
        if FileManager.default.fileExists(atPath: getDocumentsDirectory().appendingPathComponent("\(filePath).png").path) {
            let imageURL = getDocumentsDirectory().appendingPathComponent("\(filePath).png")
            let image = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        else {
            print("FILE DOES NOT EXIST AT PATH: \(getDocumentsDirectory().appendingPathComponent("\(filePath).png"))")
        }
        print("FETCH IMAGE ERROR: RETURNED IMAGE IS NIL")
        return nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func showImagePicker(presentingVC : UIViewController) -> UIImagePickerController! {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            //            delegate.shouldRotate = true
            delegate.setPeferredOrientation(orientation: .portrait)
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.modalPresentationStyle = .currentContext
            imagePickerController.delegate = presentingVC as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType    = UIImagePickerController.SourceType.photoLibrary
            imagePickerController.allowsEditing = false
            
            return imagePickerController
        }
        return nil
    }
    
}


