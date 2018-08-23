//
//  Timelines.swift
//  Stego
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

enum Timelines: ApiEndpoint {
    
//    GET /api/v1/timelines/home
    case home
    
    var route: RouteInfo {
        
        let basePath = "timelines"
        
        let result: RouteInfo
        
        switch self {
        case .home:
            
//            local     Only return statuses originating from this instance (public and tag timelines only)     yes
//            only_media     Only return statuses that have media attachments (public and tag timelines only)     yes
//            max_id     Get a list of timelines with ID less than this value     yes
//            since_id     Get a list of timelines with ID greater than this value     yes
//            limit     Maximum number of statuses on the requested timeline to get (Default 20, Max 40)     yes
            
            let params: [String: Any] = [
                "limit": "3"
            ]
            
            result = RouteInfo(method: .get, path: "\(basePath)/home", parameters: params)
        }
        
        return result
    }
    
    var resultType: Decodable.Type {
        
        switch self {
        case .home:
            return [Status].self
        }
    }
    
    func preSave(_ result: Decodable) {
        
        switch self {
        case .home:
            
            Log("\(type(of: self)) - \(#function): Got here!")
            guard let statuses = result as? [Status] else {
                fatalError("Wrong type")
            }
            
            for status in statuses {
                status.isInHomeFeed = true
            }
        }

    }
}
