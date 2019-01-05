//
//  UIColor+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    public func isEqualTo(_ color: UIColor) -> Bool {
        return self.red() == color.red() && self.green() == color.green() && self.blue() == color.blue()
    }
}
