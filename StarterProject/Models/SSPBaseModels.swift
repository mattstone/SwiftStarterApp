//
//  SSPBaseModel.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//


enum SSPPagingMeta {
    case first
    case previous
    case next
    case last
}

class SSPPaging {
    var limit  = 50 as Int
    var offset =  0 as Int
    var total  =  0 as Int
    
    // add paging to parameters dictionary
    func addPaging(paging : SSPPagingMeta = .first, parameters : Dictionary<String, Any> = [:] ) -> Dictionary<String, Any> {
        
        var dict = parameters
        
        switch paging {
        case .first:    offset = 0
        case .previous: offset = max(0, offset - limit)
        case .next:     offset = min(offset + limit, total - limit)
        case .last:     offset = max(0, total - limit)
        }
        
        dict["skip"]  = offset as Any?
        dict["limit"] = limit as Any?
        
        return dict
    }
}

class SSPBaseModels {
    
    let config      = SSPConfig.sharedInstance
    let includes    = SSPIncludes.sharedInstance
    let restAPI     = SSPURLRouter.sharedInstance
    let httpHandler = SSPHTTPHandler.sharedInstance

    var modelName      = "" as String
    var responseString = "" as String
    var responseObject =  Dictionary<String, Any>()
    var responseArray  = [Dictionary<String, Any>]()
    var errors         = [Dictionary<String, String>]()

    public func get(query : Dictionary<String, Any> = [:], access_token : String, notifier: String) {
        var urlDict = restAPI.restURL(modelName) as Dictionary<String, Any>
        
        switch query.isEmpty {
        case true:  break
        case false: urlDict["parameters"] = query
        }
        
        httpHandler.httpGet(urlDict: urlDict, notification: notifier, access_token: access_token)
    }

    public func handleGet(notification : Notification) {
        clearAll()
        httpHandler.handleResponse(notification: notification, jsonObjectToFind: modelName)

        switch httpHandler.isError() {
        case true: errors = httpHandler.errors
        case false:
            responseString = httpHandler.responseString
            responseObject = httpHandler.responseObject
            responseArray  = httpHandler.responseArray
        }
    }
    
    private func clearAll() {
        responseString = ""
        responseObject.removeAll()
        responseArray.removeAll()
        errors.removeAll()
    }
    
    public func isError() -> Bool { return !errors.isEmpty }


    public func simpleErrorMessage() -> String {
        if errors.first != nil {
            if let element = errors.first { return element["description"]! }
        }
        return ""
    }

}


class SSPBaseModel {
    
    let config      = SSPConfig.sharedInstance
    let includes    = SSPIncludes.sharedInstance
    let restAPI     = SSPURLRouter.sharedInstance
    let httpHandler = SSPHTTPHandler.sharedInstance

    var modelName      = "" as String
    var id             = "" as String
    
    var responseString = "" as String
    var responseObject =  Dictionary<String, Any>()
    var responseArray  = [Dictionary<String, Any>]()
    var errors         = [Dictionary<String, String>]()
    
    // Pagination
    lazy var paging = SSPPaging()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {}
    
    deinit {
        config.nc.removeObserver(self)  // remove any observers
    }
    
    public func extractModel(dict: Dictionary<String, Any>) {}

    public func show(query : Dictionary<String, Any> = [:], access_token : String, notifier: String) {
        var urlDict = restAPI.restURL(modelName, id: id) as Dictionary<String, Any>

        switch query.isEmpty {
        case true:  break
        case false: urlDict["parameters"] = query
        }
        
        httpHandler.httpGet(urlDict: urlDict, notification: notifier, access_token: access_token)
    }
    
    public func handleShow(notification : Notification) {
        clearAll()
        
        httpHandler.handleResponse(notification: notification, jsonObjectToFind: modelName)
        
        switch httpHandler.isError() {
        case true: errors = httpHandler.errors
        case false:
            responseString = httpHandler.responseString
            responseObject = httpHandler.responseObject
            responseArray  = httpHandler.responseArray
        }
        
        switch isError() {
        case true: print("\(modelName).handleShow error: : \(errors)")
        case false: extractModel(dict: responseObject)
        }
    }
    
    public func update(query : Dictionary<String, Any> = [:], access_token : String, notifier: String) {
        var urlDict = restAPI.restURL(modelName, id: id) as Dictionary<String, Any>
        
        switch query.isEmpty {
        case true:  break
        case false: urlDict["parameters"] = query
        }
        
        httpHandler.httpPut(urlDict: urlDict, access_token: access_token, notification: notifier)
    }
    
    public func handleUpdate(notification : Notification) {
        httpHandler.handleResponse(notification: notification, jsonObjectToFind: modelName)
        
        switch httpHandler.isError() {
        case true: errors = httpHandler.errors
        case false:
            responseString = httpHandler.responseString
            responseObject = httpHandler.responseObject
            responseArray  = httpHandler.responseArray
        }
        
        switch isError() {
        case true: print("\(modelName).handleUpdate error: : \(errors)")
        case false: extractModel(dict: responseObject)
        }

    }

    public func delete(query : Dictionary<String, Any> = [:], access_token : String, notifier: String) {
        var urlDict = restAPI.restURL(modelName, id: id) as Dictionary<String, Any>
        
        switch query.isEmpty {
        case true:  break
        case false: urlDict["parameters"] = query
        }
        
        httpHandler.httpDelete(urlDict: urlDict, access_token: access_token, notification: notifier)
    }
    
    public func handleDelete(notification : Notification) {
        httpHandler.handleResponse(notification: notification, jsonObjectToFind: modelName)
        
        switch httpHandler.isError() {
        case true: errors = httpHandler.errors
        case false:
            responseString = httpHandler.responseString
            responseObject = httpHandler.responseObject
            responseArray  = httpHandler.responseArray
        }
        
        switch isError() {
        case true: print("\(modelName).handleDelete error: : \(errors)")
        case false: extractModel(dict: responseObject)
        }

    }

    private func clearAll() {
        responseString = ""
        responseObject.removeAll()
        responseArray.removeAll()
        errors.removeAll()
    }
    
    public func isError() -> Bool { return !errors.isEmpty }
    
    public func simpleErrorMessage() -> String {
        if errors.first != nil {
            if let element = errors.first { return element["description"]! }
        }
        return ""
    }

}
