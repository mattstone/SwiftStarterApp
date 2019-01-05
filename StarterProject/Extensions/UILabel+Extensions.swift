//
//  UILabel.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import UIKit


public extension UILabel {
    
    func setHTMLFromString(htmlText: String) {
        
        // When using a HTML string we need to insert all the different properties from the Storyboard Inspector for this label,
        // into this html style string
        
        // We need to convert the UIColor to hexidecimal format for HTML style tags
        let hexColour = textColor.hexString()
        //print("THE HEX STRING IS: \(hexColour)")
        let modifiedFont = String(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize); color: \(hexColour!)\">%@</span>", htmlText)
        
        //process collection values
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        self.attributedText = attrStr
    }
}


public extension UITextView {
    func setHTMLFromString(htmlText: String) {
        // When using a HTML string we need to insert all the different proerpties from the Storyboard Inspector for this label,
        // into this html style string
        
        // Link Fix - remove anchor tag and url attribute
        let regex = try! NSRegularExpression(pattern: "<a[^>]*>|</a>", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, htmlText.count)
        let htmlTextLinkFix = regex.stringByReplacingMatches(in: htmlText, options: [], range: range, withTemplate: "")
        
        // We need to convert the UIColor to hexidecimal format for HTML style tags
        let hexColour = textColor?.hexString()
        //print("THE HEX STRING IS: \(hexColour)")
        let modifiedFont = String(format:"<span style=\"text-align: left; font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize); color: \(hexColour!)\">%@</span>", htmlTextLinkFix)
        
        //process collection values
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        self.attributedText = attrStr
    }
}
