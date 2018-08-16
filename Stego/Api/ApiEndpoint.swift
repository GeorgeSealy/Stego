//
//  Api+Call.swift
//  Stego
//
//  Created by George Sealy on 15/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiRequest {
    func cancel()
}

struct RouteInfo {
    let method: Alamofire.HTTPMethod
    let path: String
    let parameters: [String: Any]
    
    init(
        method: Alamofire.HTTPMethod,
        path: String,
        parameters: [String: Any] = [:]) {
        
        self.method = method
        self.path = path
        
        self.parameters = parameters
        
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

protocol ApiEndpoint {
    var route: RouteInfo { get }
    var resultType: Decodable.Type { get }
}
