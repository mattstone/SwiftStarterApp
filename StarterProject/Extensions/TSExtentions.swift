//
//  TSExtentions.swift
//  StarterProject
//
//  Created by Matt Stone on 25/05/2016.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

/*
 
Consolidated all extentions into one file.
 
To speed up swift compliation, Apple recommends creating one large file instead of many small files
 
*/

import Foundation
import UIKit
import SpriteKit

extension SKScene {
    
    static func loadSceneWithClassNamed(className: String, fileNamed fileName: String) -> SKScene.Type? {
        
        let appName    = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let sceneClass = NSClassFromString("\(appName).\(className)")
        return sceneClass as! SKScene.Type?//.init(fileNamed: fileName)
    }
}

extension String {
    
    func snakeCased() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
    
    func localized(comment : String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    func stringByAppendingPathComponent(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        return self[from..<self.count]
    }
    
    func substring(to: Int) -> String {
        let indexEndOfText = self.index(self.endIndex, offsetBy: to)
        return String(self[..<indexEndOfText])
    }
    
    func substring(with r: Range<Int>) -> String {
//        let startIndex = index(from: r.lowerBound)
//        let endIndex = index(from: r.upperBound)
//        return substring(with: startIndex..<endIndex)
        return self[r]
    }

    func contains(_ string: String, option: String.CompareOptions) -> Bool {
        if let _ = self.range(of: string, options: .caseInsensitive) {
            return true
        }
        return false
    }
    

//    
//    func toDate() -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV" //Your date format
//        dateFormatter.locale = Locale.init(identifier: "en_AU")
//        let date = dateFormatter.date(from: self)
//        return date!
//    }    
}

public extension UIWindow {
    
    func capture() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension UIView {
    // Round corners in storyboard - rounds all corners in view
    
    func toImage() -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius  = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // round corners in code
    // usage: view.roundCorners([.TopLeft , .BottomLeft], radius: 10) - can pick which corners to round
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension Double {
    /// Rounds the double to decimal places value
//    mutating func roundToDecimalPlace(places : Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        var number : Double = self * divisor
//        return number.round(.toNearestOrEven) / divisor
//    }
    
    ///Return seconds as hours
    func hours() -> Double {
        return self/3600
    }
    ///Return seconds as minutes
    func minutes() -> Double {
        return self/60
    }
    
    func getDollarFormatForPoints(points : Int = 0) -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = points
        formatter.minimumFractionDigits = points
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func getStringDollarFormatForDouble() -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func igSignificantFigs() -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if self < pow(10.0, Double(4)) {
            formatter.maximumSignificantDigits = 6
        }
        else {
            formatter.maximumSignificantDigits = Int(log10(self)) + 3
        }
        formatter.minimumSignificantDigits = 3
        formatter.usesGroupingSeparator = false
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func significantFigs(decimalPlaces: Int) -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if self != 0 && !self.isNaN {
            formatter.maximumSignificantDigits = Int(log10(abs(self))) + decimalPlaces + 1
        }
        else {
            formatter.maximumSignificantDigits = 2
        }
        formatter.minimumSignificantDigits = 2
        formatter.usesGroupingSeparator    = false
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func doubleToSixDecimalPlaceString() -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 6
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func doubleToZeroDecimalPlaces() -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func doubleToDecimal(places: Int) -> String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = places
        formatter.minimumFractionDigits = places
        return formatter.string(from: NSNumber(value: self))!
    }
    
    func isInt() -> Bool {
        return self.truncatingRemainder(dividingBy: 1) == 0
    }
}

extension Character {
    var integerValue:Int {
        return Int(String(self)) ?? 0
    }
}

extension Array where Element : Equatable {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }

}

extension NSNumber {
    
    func currencyAUDFormat() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_AU")
        formatter.numberStyle = .currency
        return formatter.string(from: self)!
    }
    
}

extension UIColor {
    
    convenience init(_ red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
        let redPart: CGFloat = CGFloat(red) / 255
        let greenPart: CGFloat = CGFloat(green) / 255
        let bluePart: CGFloat = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
        
    }
    
    func adjustBrightness(to percentage:CGFloat = 100.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r * percentage/100, 1.0),
                           green: min(g * percentage/100, 1.0),
                           blue: min(b * percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}


