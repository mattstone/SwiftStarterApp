//
//  NSDateFormatter+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

public extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
    }
    convenience init(timeStyle: DateFormatter.Style) {
        self.init()
        self.timeStyle = timeStyle
    }
}
