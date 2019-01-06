//
//  SSPRestRouter.swift
//  StarterProject
//
//  Created by Matt Stone on 4/1/19.
//  Copyright © 2019 Internet Schminternet. All rights reserved.
//
// Performs two functions
//
// 1. Holds list of valid urls (similar to rails router)
//
// 2. Performs HTTP & HTTPS requests and passes response back to caller via notifications
//


import Foundation

enum restVerb {
    case SHOW
    case CREATE
    case UPDATE
    case DELETE
}

enum httpMethod {
    case GET
    case PUT
    case POST
    case PATCH
    case DELETE
}

class SSPURLRouter : NSObject {

    
    static let sharedInstance = SSPURLRouter()
    let config   = SSPConfig.sharedInstance
    let includes = SSPIncludes.sharedInstance
    
    var apiUrl          = "" as String
    var appleReceiptUrl = "" as String
    var restApiUrl      = "" as String
    var distributionUrl = "" as String
    var port            = 0
    
    fileprivate override init () {
        // TODO - move to config
        apiUrl          = "\(config.baseUrl)/api"
        appleReceiptUrl = "https://musashi.tradesamurai.com/apis/apple/validateReceipts"
        restApiUrl      = "\(config.baseUrl)/api/rest"
        port            = config.requestPort
        
        super.init()
    }
    
    // Users - url Router
    func users(id : String = "") -> Dictionary<String, Any> {
        
        var url = "\(restApiUrl)/users"
        
        if !id.isEmpty { url += "/\(id)" }
        
        return [
            "url" : url as Any,
            "parameters" : Dictionary<String, String>() as Any
        ]
    }
    
    func userSignup(email    : String,
                    password : String,
                    passwordConfirmation : String = "",
                    firstName: String = "",
                    lastName : String = "",
                    alias:     String = "",
                    channel:   String = "",
                    campaign:  String = "",
                    gender:     Int   = 0,
                    isBeta: Bool) -> Dictionary<String, Any> {
        
        var dict = Dictionary<String, Any>()
        dict["url"] = "\(config.baseUrl)/signup" as Any?
        
        var parameters : Dictionary<String, Any> = [
            "email"      : email as Any,
            "password"   : password as Any,
            "passwordConfirmation" : passwordConfirmation as Any,
            "firstName"  : firstName as Any,
            "lastName"   : lastName as Any,
            "alias"      : alias as Any,
            "gender"     : gender as Any,
            "isBeta"     : isBeta as Bool
        ]
        
        if channel  != "" { parameters["channel"]  = channel as Any? }
        if campaign != "" { parameters["campaign"] = campaign as Any? }
        
        dict["parameters"] = parameters as Any?
        return dict
    }
    
    func userEmailConfirmCode(emailConfirmCode: String) -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["url"] = "\(config.baseUrl)/confirmApp/\(emailConfirmCode)" as Any?
        dict["parameters"] = [] as Any
        return dict
    }
    
    func userLogin(email: String, password: String) -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["url"] = "\(config.baseUrl)/login" as Any?
        dict["parameters"] = [
            "email"    : email as Any,
            "password" : password as Any
            ]  as Any
        return dict
    }
    
    func checkPassword(email: String, password: String) -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["url"] = "\(apiUrl)/checkPassword" as Any?
        dict["parameters"] = [
            "email"    : email as Any,
            "password" : password as Any
            ]  as Any
        return dict
    }
    
    func userPasswordReset(email : String) -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["url"] = "\(config.baseUrl)/password/reset" as Any?
        dict["parameters"] = [ "email" : email]  as Any
        
        print("userPasswordReset: \(dict)")
        
        return dict
    }
    
    func userDevices(model : String, osVersion: String, token : String) -> Dictionary<String, Any> {
        let dict = [
            "user_device" : [
                "operating_system_version" : osVersion,
                "model"                    : model,
                "device_token"             : token
            ]
        ]
        
        return [
            "url" : "\(restApiUrl)/user_devices" as Any,
            "parameters" : dict as Any
        ]
    }
    
    func userDevicesNotLoggedIn(model : String, osVersion: String, token : String) -> Dictionary<String, Any> {
        return [
            "url" : "\(config.baseUrl)/user_devices" as Any,
            "parameters" : [
                "operating_system_version" : osVersion,
                "model"                    : model,
                "device_token"             : token
                ]  as Any
        ]
    }
    
    func userByFB(fbToken : String) -> Dictionary<String, Any> {
        return [
            "url" : "\(apiUrl)/fbauth?token=\(fbToken)" as Any,
            "parameters" : Dictionary<String, String>() as Any
        ]
    }
    
    func userByID(id : String) -> Dictionary<String, Any> {
        return [
            "url" : "\(restApiUrl)/users/\(id)" as Any,
            "parameters" : Dictionary<String, String>() as Any
        ]
    }
    
    // REST
    
    public func restURL(_ modelName : String, id : String = "") -> Dictionary<String, Any> {
        var url = "\(restApiUrl)/\(modelName)"
        
        if !id.isEmpty { url = "\(url)/\(id)" }
        
        return [
            "url" : url as Any,
            "parameters" : Dictionary<String, String>() as Any
        ]
    }
    
    // HTTP
    
    func parametersAddAccessToken(access_token : String, parameters: Dictionary<String, String>) -> Dictionary<String, String> {
        if access_token == "" { return parameters }
        
        var p = parameters   // parameters are immutable.. so make temp var
        p["access_token"] = access_token
        return p
    }
    
    func buildNSMutableURLRequest(httpMethod: String, url : String, parameters : Dictionary<String, Any>, access_token : String = "") -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        do {
            // JSON serialize parameters
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            request.httpMethod = httpMethod
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
            request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("\(jsonData.count)",  forHTTPHeaderField: "Content-Length")
            request.setValue("\(access_token)",    forHTTPHeaderField: "access_token")
            
            switch request.httpMethod {
            case "GET": break
            default:    request.httpBody = jsonData
            }
        } catch { print("TSRestAPI.buildNSMutableURLRequest : \(error)") }
        
        return request
    }
    
    func httpRequest(method : httpMethod, urlDict: Dictionary<String, Any>, access_token: String, delegate: Any) -> NSMutableURLRequest {
        
        var url        = ""
        var parameters = Dictionary<String, Any>()
        
        // Swift safe typing malarkey..
        if let temp = urlDict["url"] as? String { url = temp }
        
        if let temp = urlDict["parameters"] as? Dictionary<String, Any> { parameters = temp }
        
        switch method {
        case .GET:
            var parametersString = ""
            for (key, value) in parameters { parametersString += "\(key)=\(value)&" }
            
            parameters.removeAll()
            return buildNSMutableURLRequest(httpMethod: "GET", url : url, parameters : parameters, access_token: access_token)
            
        case .POST, .PUT, .PATCH:
            
            var httpMethod = ""
            
            switch method {
            case .POST:  httpMethod = "POST"
            case .PUT:   httpMethod = "PUT"
            case .PATCH: httpMethod = "PATCT"
            default:     httpMethod = ""  // Should not get here..
            }
            
            return buildNSMutableURLRequest(httpMethod: httpMethod, url : url, parameters : parameters, access_token: access_token)
            
        case .DELETE: break
        }
        
        return NSMutableURLRequest()
    }
    
    
    func httpResponse(data: Data?, response : URLResponse, error : NSError?) -> Dictionary<String, Any> {
        var httpResponse = Dictionary<String, Any>()
        
        if error != nil {
            httpResponse["error"] = error!
        } else {
            do {
                if let http = response as? HTTPURLResponse {
                    
                    switch http.statusCode {
                    case 200:
                        if data != nil {
                            switch String(describing: data!) {
                            case "<>": httpResponse["json"] = Dictionary<String, Any>() as Any?
                            default: httpResponse["json"] = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                            }
                        }
                    case 400: httpResponse["error"] = "Bad Request"  as Any?
                    case 401: httpResponse["error"] = "Unauthorised" as Any?
                    case 402: httpResponse["error"] = "Payment Required" as Any?
                    case 403: httpResponse["error"] = "Forbidden"    as Any?
                    case 404: httpResponse["error"] = "Not Found"    as Any?
                    case 405: httpResponse["error"] = "Method Not Allowed" as Any?
                    case 406: httpResponse["error"] = "Not Acceptable"     as Any?
                    case 407: httpResponse["error"] = "Proxy Authentication requried" as Any?
                    case 408: httpResponse["error"] = "Request Timeout"    as Any?
                    case 409: httpResponse["error"] = "Conflict"     as Any?
                    //                    case 408: httpResponse["error"] = "Gone" as Any?
                    default:  httpResponse["error"] = "Unknown"      as Any?
                    }
                }
            } catch {
                httpResponse["error"] = "Invalid response from server" as Any?
            }
        }
        return httpResponse
    }
    
    // Handle JSON Response..
    
    func jsonResponse(_responseData: NSMutableData) -> NSDictionary {
        var dictionary = NSDictionary()
        
        do {
            let responseString = NSString(data:_responseData as Data, encoding:String.Encoding.utf8.rawValue)
            let jsonData       = responseString!.data(using: String.Encoding.utf8.rawValue)
            
            dictionary = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! NSDictionary
            
        } catch { print("TSRestAPI.jsonResponse: \(error)") }
        
        return dictionary
    }
}
