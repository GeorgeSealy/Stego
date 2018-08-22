//
//  AppModel.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

// POST /api/v1/apps

enum Apps: ApiEndpoint {
    
    case get
    
    var route: RouteInfo {
        
        let basePath = "apps"
        
        let result: RouteInfo
        
        switch self {
        case .get:
            
            let params: [String: Any] = [
                "client_name": "Stego Test",
                "redirect_uris": "stego://auth",
                "scopes": "read write follow",
                "website": "https://zeen.com"
            ]

            result = RouteInfo(method: .post, path: basePath, parameters: params)
        }
        
        return result
    }

    var resultType: Decodable.Type {
        
        switch self {
        case .get:
            return AppModel.self
        }
    }
    
    func preSave(_ result: Decodable) {}

}
