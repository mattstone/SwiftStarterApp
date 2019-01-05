//
//  UIView+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    func addGradient(colors: [UIColor], gradientAlpha: CGFloat = 1) {
        let layer = self.layer
        layer.masksToBounds = true
        //layer.borderWidth = 3
        //layer.borderColor = SKColorWithRGB(r: 0, 0, 255).cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = layer.bounds
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.withAlphaComponent(gradientAlpha).cgColor)
        }
        gradient.colors = cgColors
        
        let colorCount = colors.count - 1
        var locations = [NSNumber]()
        for (index, _) in colors.enumerated() {
            locations.append(NSNumber(value: Double(index) * (1.0 / Double(colorCount))))
        }
        gradient.locations = locations
        let sublayers = self.layer.sublayers
        self.layer.sublayers?.removeAll()
        self.layer.addSublayer(gradient)
        if let sl = sublayers {
            for layer in sl {
                if !(layer is CAGradientLayer) {
                    self.layer.addSublayer(layer)
                }
            }
        }
    }
    
    func addBorder(width: CGFloat, color: UIColor = UIColor.black) {
        let layer = self.layer
        layer.masksToBounds = true
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func modify(x: CGFloat! = nil, y: CGFloat! = nil, width: CGFloat! = nil, height: CGFloat! = nil) {
        var _x      = self.frame.origin.x
        var _y      = self.frame.origin.y
        var _width  = self.frame.width
        var _height = self.frame.height
        
        if x        != nil { _x = x }
        if y        != nil { _y = y }
        if width    != nil { _width = width }
        if height   != nil { _height = height }
        
        self.frame = CGRect(x: _x, y: _y, width: _width, height: _height)
    }
    
    func alphaGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        let _mask = CAGradientLayer()
        _mask.startPoint    = startPoint
        _mask.endPoint      = endPoint
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
        let colorCount = colors.count - 1
        var locations = [NSNumber]()
        for (index, _) in colors.enumerated() {
            locations.append(NSNumber(value: Double(index) * (1.0 / Double(colorCount))))
        }
        _mask.colors     = cgColors
        _mask.frame      = bounds
        layer.mask       = _mask
    }
    
    func addShadow(color: UIColor = UIColor.black, offset: CGSize = CGSize(width: 0.5, height: 0.5), radius: CGFloat = 0.666) {
        layer.shadowOffset  = offset
        layer.shadowColor   = color.cgColor
        layer.shadowRadius  = radius
        layer.shadowOpacity = 1
    }
    
    // Safe area
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) { return self.safeAreaLayoutGuide.topAnchor }
        return self.topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) { return self.safeAreaLayoutGuide.leftAnchor }
        return self.leftAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) { return self.safeAreaLayoutGuide.rightAnchor }
        return self.rightAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) { return self.safeAreaLayoutGuide.bottomAnchor }
        return self.bottomAnchor
    }
}

public extension UILabel {
    
    /**
     * Resize the label to fit a certain width you pass in
     */
    
    func fitToWidth(width: CGFloat, speed: CGFloat = 1) {
        //print(self.intrinsicContentSize)
        while self.intrinsicContentSize.width > width /** 0.5*/ { self.font = self.font.withSize(self.font.pointSize - speed)}
    }
    
    func modifyFont(name: String! = nil, size: CGFloat! = nil) {
        var _name = self.font.fontName
        var _size = self.font.pointSize
        
        if name != nil { _name = name }
        if size != nil { _size = size }
        
        self.font = UIFont(name: _name, size: _size)
    }
}
