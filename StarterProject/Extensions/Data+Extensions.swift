//
//  Data+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//
//

import Foundation
import UIKit

public extension Data {
    
    var uiImage: UIImage? {
        return UIImage(data: self)
    }
    
}
