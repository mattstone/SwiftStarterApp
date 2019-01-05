//
//  SSPChildModel.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

class SSPChildModels : SSPBaseModels {
    
    static let sharedInstance = SSPChildModels()
    
    var childModels = [SSPChildModel]()
    var childModel  : SSPChildModel!
    
    private override init() {
        super.init()
        
        modelName = "childModels"
    }
    
    override func handleGet(notification: Notification) {
        super.handleGet(notification: notification)

        switch isError() {
        case true:  print("DRAGON REPORT GET FAILURE: \(errors)")
        case false:
            for object in responseArray {
                let childModel = SSPChildModel()
                childModel.extractModel(dict: object)
                childModels.append(childModel)
            }
        }
    }
    
}

class SSPChildModel : SSPBaseModel {
    
    // define model variables here..
    
    override func extractModel(dict: Dictionary<String, Any>) {
        // use extract functions from SSPHTTPHandler to extract variables from JSON
    }
    
    override func handleShow(notification: Notification) {
        super.handleShow(notification: notification)
    }
    
    override func handleUpdate(notification: Notification) {
        super.handleUpdate(notification: notification)
    }
    
    override func handleDelete(notification: Notification) {
        super.handleDelete(notification: notification)
    }
    
}

