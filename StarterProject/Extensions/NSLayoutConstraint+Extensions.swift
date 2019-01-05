//
//  NSLayoutConstraint+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import UIKit

public extension NSLayoutConstraint {
    func modify(relation: NSLayoutConstraint.Relation = NSLayoutConstraint.Relation(rawValue: 1)!) -> NSLayoutConstraint {
        let modConstraint =  NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: self.multiplier, constant: self.constant)
        modConstraint.identifier = self.identifier
        return modConstraint
    }
}
