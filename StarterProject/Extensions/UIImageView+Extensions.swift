//
//  UIImageView+Extensions.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation
import UIKit

private var initImgKey : UInt8 = 0

public extension UIImageView {
    var initImg : UIImage! {
        get {
            if let img = objc_getAssociatedObject(self, &initImgKey) as? UIImage {
                return img
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &initImgKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func tint(with color: UIColor, blendMode: CGBlendMode) {
        if initImg == nil {
            initImg = image
        }
        
        image = initImg.tint(color: color, blendMode: blendMode)
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, id: (String, String)) {
        contentMode = mode
    
        let config = SSPConfig.sharedInstance
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, response, error in
            if let e = error {
                print("IMAGE DOWNLOAD ERROR: COULD NOT DOWNLOAD IMAGE: \(e)")
                config.nc.post(name: config.notifiers.SSP_IMAGE_FETCH_SUCCESS, object: "generalError")
            }
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                print("IMAGE DOWNLOAD ERROR: COULD NOT RESPONSE 200 CODE")
                config.nc.post(name: config.notifiers.SSP_IMAGE_FETCH_SUCCESS, object: "responseError")
                return
            }
            guard let data = data else {
                config.nc.post(name: config.notifiers.SSP_IMAGE_FETCH_SUCCESS, object: "dataError")
                print("IMAGE DOWNLOAD ERROR: COULD NOT GET DATA FROM RESPONSE")
                return
            }
            
            guard let i = UIImage(data: data) else {
                config.nc.post(name: config.notifiers.SSP_IMAGE_FETCH_SUCCESS, object: "imageError")
                print("IMAGE DOWNLOAD ERROR: COULD NOT GET IMAGE FROM DATA")
                return
            }
            DispatchQueue.main.async() {
                print("IMAGE DOWNLOAD COMPLETE")
                self.image = i
                config.nc.post(name: config.notifiers.SSP_IMAGE_FETCH_SUCCESS, object: (i, id))
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, id: (String, String)) -> Bool {
        guard let url = URL(string: link) else {
            if link.isEmpty {
                 print("IMAGE DOWNLOAD ERROR: EMPTY URL STRING")
            }
            else {
                print("IMAGE DOWNLOAD ERROR: NIL OR BADLY FORMED IMAGE URL STRING: \(link)")
            }
            return false
        }
        downloadedFrom(url: url, contentMode: mode, id: id)
        return true
    }
}
