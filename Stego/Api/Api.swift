//
//  Api.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import Alamofire

struct ApiRequest {
    fileprivate var request: Request
    
    func cancel() {
        self.request.cancel()
    }
}

struct RouteInfo {
    let method: Alamofire.HTTPMethod
    let path: String
    let parameters: [String: Any]?
    
    init(
        method: Alamofire.HTTPMethod,
        path: String,
        parameters: [String: Any]?) {
        //        paginationParams: PaginationRequest? = nil) {
        
        self.method = method
        self.path = path
        
        var theParams: [String: Any] = [:]
        if let defParams = parameters {
            theParams = defParams
        }
        
        //        // TODO: (George) REPLACE WITH MASTODON SCHEME?
        //        if let pagination = paginationParams {
        //
        //            if let anchor = pagination.anchor {
        //                if pagination.isRefresh {
        //                    theParams["recent_anchor"] = anchor
        //                } else {
        //                    theParams["anchor"] = anchor
        //                }
        //            }
        //
        //            theParams["limit"] = pagination.limit
        //
        //        }
        
        self.parameters = theParams
        
    }
    
    // Allow full api path to be sent through...
    fileprivate var fullPath = false
    var isFullPath: Bool {
        set(isFull) {
            self.fullPath = isFull
        }
        get {
            return self.fullPath
        }
    }
    
    fileprivate var isApi = true
    var isApiCall: Bool {
        set(value) {
            self.isApi = value
        }
        get {
            return self.isApi
        }
    }
}

class Api {
    
    static let basePath = "https://mastodon.social/"
    
    static var app: AppModel?
    static var accessCode: String?
    static var accessToken: String?

    static func register() {
        
        guard let app = Api.app else {

            _ = Apps.get { (result) in
                
                switch result {
                    
                case .success(let app):
                    print("\(type(of: self)) - \(#function): Success: \(app)")
                    
                    Api.app = app
                    register()
                    
                case .error(let error) :
                    print("\(type(of: self)) - \(#function): Error: \(error)")
                    
                }
            }
            
            return
        }
        
        if let code = Api.accessCode {
            print("\(type(of: self)) - \(#function): Got refresh token: \(code)")
            
            _ = Oauth.accessToken(clientId: app.clientId,
                            clientSecret: app.clientSecret,
                            code: code,
                            redirectUri: app.redirectUri,
                            completion: { (result) in
                                
                                switch result {
                                    
                                case .success:
                                    print("\(type(of: self)) - \(#function): Success token")
                                    
                                case .error(let error) :
                                    print("\(type(of: self)) - \(#function): Error: \(error)")
                                    
                                }
            })
            
        } else if let accessToken = Api.accessToken {
            print("\(type(of: self)) - \(#function): Got access token: \(accessToken)")
        } else {
            
            var path = Api.basePath + "oauth/authorize"
            
            path = path + "?response_type=code"
            path = path + "&scope=read+write+follow"
            path = path + "&redirect_uri=\(app.redirectUri)"
            path = path + "&client_id=\(app.clientId)"
            
            guard let url = URL(string: path) else {
                print("ERROR WITH PATH: \(path)")
                return
            }
            
            let options: [String: Any] = [:]
            
            print("Redirecting to : \(url.absoluteString)")
            UIApplication.shared.open(url, options: options, completionHandler: { (success) in
                print("Redirected \(success)")
            })
            
            return
        }

    }
    
    static func call<T: Decodable>(_ endpointInfo: RouteInfo, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void) -> ApiRequest {
        return ApiRequest(request: internalCall(endpointInfo, allowCancelCallback: allowCancelCallback, completion: completion))
    }
    
    fileprivate static func internalCall<T: Decodable>(_ endpointInfo: RouteInfo, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void) -> Request {
        
        let fullPath = endpointInfo.isFullPath ? endpointInfo.path : String(format: "%@%@%@", basePath, endpointInfo.isApiCall ? "api/v1/" : "", endpointInfo.path)
        print("\(fullPath) [\(endpointInfo.method.rawValue)]")
        
        var parameters = [String: Any]()
        if let params = endpointInfo.parameters {
            parameters = params
        }
        
        print("\(type(of: self)) - \(#function): Params: \(parameters)")
        let method = endpointInfo.method
        let encoding: ParameterEncoding = ([Alamofire.HTTPMethod.head, Alamofire.HTTPMethod.get, Alamofire.HTTPMethod.delete].contains(method) ? URLEncoding.default  : JSONEncoding.default)
        
        let request = Alamofire.request(fullPath, method: method, parameters: parameters, encoding: encoding).validate().responseData { (response) in
            
            do {
                guard let data = response.data else {
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: "Sorry, there was an error deserializing the api response",
                        ]
                    
                    let error = NSError(domain: "ApiDomain", code: -1, userInfo: userInfo)
                    
                    self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .error(error as NSError))
                    return
                }
                
                print("RESPONSE: \(data)")
                
                print("RESPONSE: \(data as? [String: Any])")

                let result: T = try data.decoded()
                
                self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .success(result))
            } catch let error {
                print("ERROR: \(error)")
                print("Trying string")
                return
                //                self.handleResponse(fullPath: fullPath, allowCancelCallback: allowCancelCallback, completion: completion, result: .error(error as NSError))
            }
            }.responseString { (response) in
                print("Trying string: \(response)")
        }
        
 
        return request
    }
    
    private static func handleResponse<T>(fullPath: String, allowCancelCallback: Bool = false, completion: @escaping (Result<T>) -> Void, result: Result<T>) {
        
        completion(result)
        
    }
    
}

