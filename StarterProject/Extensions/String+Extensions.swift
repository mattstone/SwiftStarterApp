//
//  String+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import SpriteKit

public extension String {
    
    //dd is day
    //MM is month
    //mm is minutes
    //yy is year
    func toDate(withFormat format: String = "dd/MM/yyyy") -> Date! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    /// Return the character at Index
//    func characterAt(index: Int) -> String {
//        let i : String.Index = self.startIndex
//        let chars = self.count
//        
//        if index > chars {
//            print("Character at index \(index) is outside of character bounds.")
//            return ""
//        }
//        return String(self[self.index(i, offsetBy: i)])
//    }
    
    func countOccurences(of char: String) -> Int {
        var count = 0
        let index : String.Index = self.startIndex
        let chars = self.count
        for i in 0..<chars {
            if String(self[self.index(index, offsetBy: i)]) == char {
                count += 1
            }
        }
        return count
    }
    
    /// Remove the count amount from the end of the string
    func removeCharsFromEnd(_ count: Int) -> String {
        return String(self.dropLast(count))
    }
    
    func removeNumsFromEnd() -> String! {
        let index : String.Index = self.startIndex
        let chars = self.count
        var i = chars - 1
        if i == -1 {
            return nil
        }
        var count = 0
        let string = self as NSString
        var char : unichar!
        char = string.character(at: i)
        while String(self[self.index(index, offsetBy: i)]).isNumber(c: char) {
            i -= 1
            count += 1
            char = string.character(at: i)
        }
        return String(self.dropLast(count))
    }
    
    /*
     * Remove the count amount from the start of the string
     */
    func removeCharsFromStart(_ count: Int) -> String {
        let index : String.Index = self.startIndex
        let chars = self.count
        var result = ""
        if (chars + 1) > count {
            for i in  count ..< chars {
                result += String(self[self.index(index, offsetBy: i)])
            }
        }
        return result
    }
    
    /*
     * Show the characters from the start till count amount
     */
    func showCharsUntil(_ count: Int) -> String {
        let index : String.Index = self.startIndex
        var result = ""
        for i in 0..<count {
            result += String(self[self.index(index, offsetBy: i)])
        }
        return result
    }
    
    /*
     * Show the characters count amount characters from the end
     */
    func lastChars(_ count: Int) -> String {
        let index : String.Index = self.startIndex
        let chars = self.count
        var result = ""
        for i in (chars - (count))...(chars - 1) {
            result += String(self[self.index(index, offsetBy: i)])
        }
        return result
    }
    
    /*
     * Remove characters from the end of the string until char is present
     */
    func removeCharsFromEndUntil(char: String) -> String! {
        let index : String.Index = self.startIndex
        let chars = self.count
        var i = chars - 1
        if i == -1 {
            return nil
        }
        var count = 1
        while String(self[self.index(index, offsetBy: i)]) != char {
            i -= 1
            count += 1
        }
        return String(self.dropLast(count))
    }
    
    /*
     * Shows the characters at the end of string after the last instance of `char`
     * Used for extracting file names from URL strings.
     */
    func showCharsFromEndAfter(char: String) -> String {
        let index: String.Index = self.startIndex
        let chars = self.count
        var i = chars - 1
        if i == -1 {
            return ""
        }
        var count = 1
        while String(self[self.index(index, offsetBy: i)]) != char {
            i -= 1
            count += 1
        }
        return self.lastChars(count - 1)
    }
    
    /*
     * Remove characters from the start of the string until char is present
     */
    func removeCharsFromStartUntil(char: String) -> String {
        let index : String.Index = self.startIndex
        let chars = self.count
        var result = ""
        var i = 0
        while String(self[self.index(index, offsetBy: i)]) != char {
            i += 1
        }
        for j in  (i + 1) ..< chars {
            result += String(self[self.index(index, offsetBy: j)])
        }
        return result
    }
    
    /*
     * Remove all characters after 'limit' instance(s) of character as decimal i.e 10 = new line, 46 = .
     */
    func removeCharsAfterDecimal(_ decimal: unichar, limit: Int = 1) -> String! {
        let nsSelf = self as NSString
        var count = 0
        var limitCount = 0
        for i in 0 ..< nsSelf.length {
            let char = nsSelf.character(at: i)
            if char == decimal { limitCount += 1 }
            if limitCount >= limit { count += 1 }
        }
        return String(self.dropLast(count))
    }
    
    /*
     * Returns number from string
     */
    func asNumber() -> CGFloat? {
        var isInt       = true
        var number      = CGFloat()
        let string      = self.stripToNumber() as NSString
        let formatter   = NumberFormatter()
        var stringNum   = ""
        for i in 0 ..< string.length {
            let char = string.character(at: i)
            if isNumber(c: char) {
                stringNum += "\(char - 48)"
            }
            else {
                number      = CGFloat(truncating: formatter.number(from: stringNum)!)
                stringNum   = ""
                isInt       = false
            }
        }
        if isInt { return CGFloat(truncating: formatter.number(from: stringNum)!) }
        
        //Add decimals numbers to end if any
        let decimals = CGFloat(truncating: formatter.number(from: stringNum)!)
        let quotient = pow(10, CGFloat(stringNum.count))
        number      += decimals / quotient
        return number
    }
    
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    /*
     * Removes all characters except numbers
     */
    func stripToNumber() -> String {
        var newString    = ""
        var decimalCount = 0
        let string = self as NSString
        for i in 0 ..< string.length {
            let char = string.character(at: i)
            if isNumber(c: char)  { newString += "\(char - 48)" }
            else if char == 46 {
                // full stop
                newString += "\u{46}"//"\(String(describing: UnicodeScalar(char)))"
                decimalCount += 1
            }
        }
        if decimalCount > 1 {
            print("CANNOT CONVERT TO NUMBER")
            newString = ""
        }
        return newString
    }
    
    /*
     * Helper method to check for numbers
     */
    func isNumber(c: unichar) -> Bool {
        if c >= 48 && c <= 57 { return true }
        return false
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    var length: Int { return self.count }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var underscoreToCamelCase: String {
        let items = self.components(separatedBy: "_")
        var camelCase = ""
        items.enumerated().forEach {
            camelCase += 0 == $0 ? $1 : $1.capitalized
        }
        return camelCase
    }
    
    func reverse() -> String {
        var str = ""
        for character in self {
            str = "\(character)" + str
        }
        return str
    }
}
