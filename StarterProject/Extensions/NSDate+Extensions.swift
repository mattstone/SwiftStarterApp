//
//  NSDate+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

public extension Date {
    
    /*
     * Return the hour(s) from date
     */
    func hour() -> Int {
        let calendar = NSCalendar.current as NSCalendar
        return  calendar.component(.hour, from: self as Date)
    }
    
    /*
     * Return the minute(s) from date
     */
    func minute() -> Int {
        let calendar = NSCalendar.current as NSCalendar
        return  calendar.component(.minute, from: self as Date)
    }
    
    /*
     * Return time as string, shortTime format
     */
    func toShortTimeString() -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self as Date)
    }
    
    /*
     * Return date as string, medium format i.e. 01 Jan 2010
     */
    func dateMediumString() -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self as Date)
    }
    
    func dateTimeMediumString() -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: self as Date)

    }
    func toLocalTime() -> Date {
        let seconds = TimeZone.current.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(seconds), since: self)
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func add(nDays n: Int) -> Date! {
        return Calendar.current.date(byAdding: .day, value: n, to: self)
    }
    
    func add(nMonths n: Int) -> Date! {
        return Calendar.current.date(byAdding: .month, value: n, to: self)
    }
    
    func day() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func isFirstDayOfMonth() -> Bool {
        return day() == 1
    }

    func isJanuary() -> Bool {
        return month() == 1
    }
    
    func monthString() -> String {
        switch self.month() {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return "None"
        }
    }
    
    func shortMonthString() -> String {
        return self.monthString().showCharsUntil(3)
    }
}
