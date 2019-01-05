//
//  SSP_OnDemandContent.swift
//  StarterProject
//
//  Created by Matt Stone on 5/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

import Foundation
import UIKit

enum SSPOnDemandResource {
    case None
    
    var tagValue: String {
        switch self {
        case .None: return "None"
        }
    }
}

class SSPOnDemandContent : NSObject {
    
    static let sharedInstance  = SSPOnDemandContent()
    
    let config   = SSPConfig.sharedInstance
    
    var  request :  NSBundleResourceRequest!
    private var progressContext = 0
    
    let keyPath       = "fractionCompleted"
    var tag           = SSPOnDemandResource.None.tagValue
    var isDownloading = false
    
    deinit {
        removeProgressObserver()
        request = nil
    }
    
    func downloadResource(tag : String, loadingPriority : Double = NSBundleResourceRequestLoadingPriorityUrgent, isLoadAll: Bool = false) {
        print("SSPOnDemandContent.downloadResource: tag: \(tag)")
        
        self.isDownloading = true
        
        // Default to most urgent loading priority
        // If you include a tag to download make sure at least one asset in the assets catalogue is given that tag otherwise there WILL be errors.
        
        switch tag {
        case "none":
            let tags = NSSet(objects: "none")
            print("Downloading TAGS: \(tags.allObjects)")
            request = NSBundleResourceRequest(tags: tags as! Set<String>)
            
        default:
            let tags = NSSet(objects: "none")
                print("Downloading TAGS: \(tags.allObjects)")
                request = NSBundleResourceRequest(tags: tags as! Set<String>)
        }
        
        
        request.loadingPriority = loadingPriority
        request.conditionallyBeginAccessingResources { resourcesAvailable in
            
            switch resourcesAvailable {
            case true:
                self.isDownloading = false
                self.config.nc.post(name: self.config.notifiers.SSP_ON_DEMAND_CONTENT_AVAILABLE, object: nil)
                
            case false:
                self.config.nc.post(name: self.config.notifiers.SSP_ON_DEMAND_CONTENT_DOWNLOAD_BEGIN, object: nil)
                self.addProgressObserver()
                
                self.request.beginAccessingResources { error in
                    self.removeProgressObserver()
                    self.isDownloading = false
                    
                    if error != nil {
                        print("SSPOnDemandContent.downloadResource: error: \(String(describing: error?.localizedDescription))")
                        
                        self.config.nc.post(name: self.config.notifiers.SSP_ON_DEMAND_CONTENT_DOWNLOAD_ERROR, object: error)
                    } else {
                        self.isDownloading = false
                        self.config.nc.post(name: self.config.notifiers.SSP_ON_DEMAND_CONTENT_AVAILABLE, object: nil)
                    }
                }
            }
        }
    }
    
    func pauseDownload()  { request.progress.pause() }
    func resumeDownload() { request.progress.resume() }
    func cancelDownload() {
        request.progress.cancel()
        self.isDownloading = false
        removeProgressObserver()
    }
    
    func addProgressObserver() {
        request.progress.addObserver(self,
                                     forKeyPath: keyPath,
                                     options: [.new, .initial],
                                     context: &self.progressContext)
    }
    
    func removeProgressObserver() {
        request.progress.removeObserver(self, forKeyPath: keyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = object as? Progress {
            if self.keyPath == keyPath! {
                //NAHTANTODO: Look at this in spare
                //                print("***\n\(request.progress)")
                config.nc.post(name: config.notifiers.SSP_ON_DEMAND_CONTENT_DOWNLOAD_UPDATE, object: request.progress)
            }
        }
    }
    
    /*
     
     // TODO: This removes all tagged resources completely.. not just the specified ones :-(
     //       So set preservation priority instead...
     
     func removeTaggedResources(tag : TSOnDemandBookResource) {
     let tags = NSSet(objects: tag.rawValue)
     request  = NSBundleResourceRequest(tags: tags as! Set<String>)
     request.endAccessingResources()
     }
     */
}
