//
//  NSDecimalNumber+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import CoreGraphics

public extension NSDecimalNumber {
    
    //This is hack
//    func levelToPoints(pair: String) -> NSDecimalNumber {
//        if pair.contains("JPY") {
//            return self / 0.01
//        }
//        return self / 0.0001
//    }
    
//    func pointsToLevel(pair: String) -> NSDecimalNumber {
//        if pair.contains("JPY") {
//            return self * 0.01
//        }
//        return self * 0.0001
//    }
    
    func round(decimalPlaces : Int) -> NSDecimalNumber {
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: Int16(decimalPlaces), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return self.rounding(accordingToBehavior: handler)
    }
}

public func > (left:NSDecimalNumber, right:NSDecimalNumber) -> Bool {
    return left.compare(right) == ComparisonResult.orderedDescending
}

public func < (left:NSDecimalNumber, right:NSDecimalNumber) -> Bool {
    return left.compare(right) == ComparisonResult.orderedAscending
}

public func >= (left:NSDecimalNumber, right:NSDecimalNumber) -> Bool {
    return left.compare(right) != ComparisonResult.orderedAscending
}

public func <= (left:NSDecimalNumber, right:NSDecimalNumber) -> Bool {
    return left.compare(right) != ComparisonResult.orderedDescending
}

public func == (left:NSDecimalNumber, right:NSDecimalNumber) -> Bool {
    return left.compare(right) == ComparisonResult.orderedSame
}

public func + (left:NSDecimalNumber, right:NSDecimalNumber) -> NSDecimalNumber {
    return left.adding(right)
}

public func * (left:NSDecimalNumber, right:NSDecimalNumber) -> NSDecimalNumber {
    return left.multiplying(by: right)
}

public func - (left:NSDecimalNumber, right:NSDecimalNumber) -> NSDecimalNumber {
    return left.subtracting(right)
}

public func / (left:NSDecimalNumber, right:NSDecimalNumber) -> NSDecimalNumber {
    //We need to make sure that the number we are dividing by is not NaN or 0
    if (right.compare(NSDecimalNumber.zero) == ComparisonResult.orderedSame) || (NSDecimalNumber.notANumber.isEqual(to: right)) {
        return NSDecimalNumber.zero
    }
    return left.dividing(by: right)
}

public func += (left:inout NSDecimalNumber, right:NSDecimalNumber) -> NSDecimalNumber {
    return left + right
}

public func -= (left:inout NSDecimalNumber, right:NSDecimalNumber) -> NSDecimalNumber {
    return left - right
}

public func abs (num: NSDecimalNumber) -> NSDecimalNumber {
    if num < 0 { return num * -1 }
    return num
}
