//
//  SSPHTTPHandler.swift
//  StarterProject
//
//  Created by Matt Stone on 5/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//

import Foundation

class SSPHTTPHandler {
    
    static let sharedInstance = SSPHTTPHandler()

 
    let config   = SSPConfig.sharedInstance
    let includes = SSPIncludes.sharedInstance
    let restAPI  = SSPURLRouter.sharedInstance
    
    // Pagination
    lazy var paging = SSPPaging()
    
    var responseString = "" as String
    var responseObject =  Dictionary<String, Any>()
    var responseArray  = [Dictionary<String, Any>]()
    var errors         = [Dictionary<String, String>]()


    func httpGet(urlDict : Dictionary<String, Any>, notification : String, access_token : String = "") {
        var request          = NSMutableURLRequest()
        var url              = "" as String
        
        if let nonOptionalString = urlDict["url"] as? String { url = nonOptionalString }
        
        var parametersString = "" as String
        
        if let string = urlDict["parameters"] as? String {
            parametersString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        } else if let parametersDict = urlDict["parameters"] as? Dictionary<String, Any> {
            for (key, value) in parametersDict {
                
                switch parametersString.isEmpty {
                case true:  parametersString = "\(key)=\(value)"
                case false: parametersString = "\(parametersString)&\(key)=\(value)"
                }
            }
            
            parametersString = parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        switch access_token.isEmpty {
        case true:  url = "\(url)?\(parametersString)"
        case false: url = "\(url)?access_token=\(access_token)&\(parametersString)"
        }
        
        request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        
        if !access_token.isEmpty {
            request.setValue("\(access_token)",    forHTTPHeaderField: "access_token")
        }
        
        let session = URLSession.shared
        let task    = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: error)
            } else {
                let httpResponse = self.restAPI.httpResponse(data: data, response: response!, error: error as NSError?)
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: httpResponse)
            }
        })
        task.resume()
    }
    
    func httpPost(urlDict : Dictionary<String, Any>, access_token: String, notification : String) {
        let request = restAPI.httpRequest(method: httpMethod.POST, urlDict: urlDict, access_token: access_token, delegate: self)
        let session = URLSession.shared
        let task    = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: error)
            } else {
                let httpResponse = self.restAPI.httpResponse(data: data, response: response!, error: error as NSError?)
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: httpResponse)
            }
        })
        task.resume()
    }
    
    func httpPut(urlDict : Dictionary<String, Any>, access_token : String, notification : String) {
        let request = restAPI.httpRequest(method: httpMethod.PUT, urlDict: urlDict, access_token: access_token, delegate: self)
        if access_token != "" { request.addValue(access_token, forHTTPHeaderField: "access_token") }
        let session = URLSession.shared
        let task    = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if (error != nil) {
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: error)
            } else {
                let httpResponse = self.restAPI.httpResponse(data: data, response: response!, error: error as NSError?)
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: httpResponse)
            }
        })
        task.resume()
    }
    
    func httpDelete(urlDict : Dictionary<String, Any>, access_token : String = "", notification : String) {
        
        var request          = NSMutableURLRequest()
        var url              = "" as String
        if let nonOptionalString = urlDict["url"] as? String { url = nonOptionalString }
        
        var parametersString = "" as String
        if let parametersDict = urlDict["parameters"] as? Dictionary<String, Any> {
            for (key, value) in parametersDict {
                
                switch parametersString.isEmpty {
                case true:  parametersString = "\(key)=\(value)"
                case false: parametersString = "\(parametersString)&\(key)=\(value)"
                }
                
            }
        }
        
        parametersString = parametersString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        switch access_token.isEmpty {
        case true:  url = "\(url)?\(parametersString)"
        case false: url = "\(url)?access_token=\(access_token)&\(parametersString)"
        }
        
        request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "DELETE"
        
        if !access_token.isEmpty {
            request.setValue("\(access_token)",    forHTTPHeaderField: "access_token")
        }
        
        let session = URLSession.shared
        let task    = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: error)
            } else {
                let httpResponse = self.restAPI.httpResponse(data: data, response: response!, error: error as NSError?)
                self.config.nc.post(name: NSNotification.Name(rawValue: notification), object: httpResponse)
            }
        })
        task.resume()
    }
    
    // Errors
    
    func clearErrors() { errors.removeAll() }
    
    func isError() -> Bool { return !errors.isEmpty }
    
    func addErrorObject(field: String, description : String, code : String) {
        errors.append(["field" : field, "description" : description, "code" : code])
    }
    
    func isJSONResponseSuccess(json : Dictionary<String, Any>) -> Bool {
        if let dict = json["json"] as? Dictionary<String, Any> {
            if dict["success"] != nil {
                if dict["success"] as! String == "OK" { return true }
            }
        }
        return false
    }
    
    func handleResponse(notification: Notification, jsonObjectToFind: String) {
        clearErrors()
        responseObject.removeAll()
        responseArray.removeAll()
        responseString = ""
        
        if let _ = notification.object as? NSError {  // No network connection
            addErrorObject(field: "", description : config.NoConnectionMessage, code : "")
        } else {
            if let responseDict = notification.object  as? Dictionary<String, Any> {
                if let jsonDict = responseDict["json"] as? Dictionary<String, Any> {
                    if let object = jsonDict["meta"]   as? Dictionary<String, Any> {
                        // Note: Limit should be set in model, not by back-end
                        //if let x = object["limit"]   as? Int { meta.limit  = x }
                        if let x = object["offset"]    as? Int { paging.offset = x }
                        if let x = object["total"]     as? Int { paging.total  = x }
                    }
                    
                    if !jsonObjectToFind.isEmpty {
                        if let object = jsonDict[jsonObjectToFind] as? Dictionary<String, Any> {
                            responseObject = object
                        } else if let array = jsonDict[jsonObjectToFind] as? [Dictionary<String, Any>] {
                            responseArray = array
                        } else if let string = jsonDict[jsonObjectToFind] as? String {
                            responseString = string
                        } else {
                            print("TSBaseModel.handleResponse: unable to extract JSON for key: \(jsonObjectToFind)")
                            handleResponseError(jsonDict: jsonDict)
                        }
                    }
                } else {
                    addErrorObject(field: "", description : "Forbidden", code : "")
                }
            }
        }
    }
    
    func handleResponseError(jsonDict : Dictionary<String, Any>) {
        /*
         
         Note: This routine will populate errors dictionary
         
         Ony run this routing if response is not valid for the operation
         
         */
        
        var message = ""
        
        if let error = jsonDict["error"] as? Dictionary<String, Any> {           // complex error
            if let errors = error["errors"] as? Dictionary<String, Any> {
                if let base = errors["base"] as? Dictionary<String, Any> {
                    if let name = base["name"] as? String {
                        switch name {
                        case "ValidatorError":
                            if let properties = base["properties"] as? Dictionary<String, Any> {
                                if let errorMsg = properties["message"] as? String { message = errorMsg }
                            }
                        default: break
                        }
                    }
                }
            }
        }
        
        // We only get here if there was an error
        if let error = jsonDict["error"] as? Dictionary<String, String> {           // simple error
            if error["message"] != nil {
                message = error["message"]!
            }
        } else {
            if let error = jsonDict["error"] as? Dictionary<String, Any> {    // complex error
                if let errors = error["errors"] as? Dictionary<String, Any> {
                    if let base = errors["base"] as? Dictionary<String, String> {
                        if base["message"] != nil {
                            message = base["message"]!
                        }
                    }
                }
                else if let errorMessage = error["message"] as? String {
                    message = errorMessage
                }
            }
        }
        
        if message == "" { message = config.UnknownError }
        addErrorObject(field: "", description : message, code : "")
    }
    
    func handleDelete(notification : Notification, key : String) {
        if let dict = notification.object as? Dictionary<String, Any> {
            
            if let json = dict["json"] as? Dictionary<String, Any> {
                if let _ = json[key] as? NSNull { return }
                handleResponseError(jsonDict: json)
            }
        }
        
        if !isError() {
            addErrorObject(field: "", description : "Unable to delete. Please try again later", code : "")
        }
    }
    
    func extractDateFromMongoISODate(key : String, dict : Dictionary<String, Any>) -> Date! {
        if let x = dict[key] as? String {
            return includes.dateFromMongoISODate(date: x) as Date?
        } else {
            return nil
        }
    }
    
    
    func extractString(key : String, dict : Dictionary<AnyHashable, Any>) -> String {
        if let x = dict[key] as? String { return x }
        return ""
    }
    
    func extractDouble(key : String, dict : Dictionary<String, Any>) -> Double {
        if let x = dict[key] as? Double { return x }
        return 0
    }
    
    // extract date from Unix TimeStamp
    func extractDateFromUTS(key : String, dict : Dictionary<String, Any>) -> Date! {
        if let x = dict[key] as? TimeInterval {
            return includes.dateFromUTS(timeInterval : x)
        } else {
            return nil
        }
    }
    
    func extractInt(key : String, dict : Dictionary<AnyHashable, Any>) -> Int {
        if let x = dict[key] as? Int { return x }
        return 0
    }
    
    func extractBool(key: String, dict : Dictionary<AnyHashable, Any>) -> Bool {
        if let x = dict[key] as? Bool { return x }
        //print("could not extract bool")
        if let _ = dict[key.underscoreToCamelCase] as? Bool {
            //  print("but alternative exisits \"\(key.underscoreToCamelCase)\"")
        } else {
            //print("-\(key)-")
        }
        return false
    }
    
    func extractDict(key: String, dict : Dictionary<AnyHashable, Any>) -> Dictionary<String, Any> {
        if let x = dict[key] as? Dictionary<String, Any> { return x }
        return [:]
    }
    
    func extractArray(key: String, dict : Dictionary<AnyHashable, Any>) -> Array<Any> {
        if let x = dict[key] as? Array<Any> { return x }
        return []
    }
    
    func extractArrayDict(key: String, dict : Dictionary<AnyHashable, Any>) -> Array<Dictionary<String, Any>> {
        if let x = dict[key] as? Array<Dictionary<String, Any>> { return x }
        return []
    }
    
    func extractId(dict : Dictionary<AnyHashable, Any>) -> String {
        if dict.extractString(key: "id") == "" {
            return dict.extractString(key: "_id")
        }
        return dict.extractString(key: "id")
    }
    
    func extractModified(dict : Dictionary<AnyHashable, Any>) -> String {
        return extractString(key: "modified", dict: dict)
    }

    
}
