//
//  AppModel.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

struct AppModel: Decodable {
    let clientId: String
    let clientSecret: String
    let id: String
    let name: String
    let redirectUri: String
    let website: String?
    
    enum CodingKey: String, Swift.CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case id
        case name
        case redirectUri = "redirect_uri"
        case website
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        clientId = try container.decode(String.self, forKey: .clientId)
        clientSecret = try container.decode(String.self, forKey: .clientSecret)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        redirectUri = try container.decode(String.self, forKey: .redirectUri)
        website = try? container.decode(String.self, forKey: .website)
    }
}

// POST /api/v1/apps

class Apps {
    
    static let basePath = "apps"
    
    static func get(_ completion: @escaping (_ apiResponse: Result<AppModel>) -> Void) -> ApiRequest {
        
        let params: [String: Any] = [
            "client_name": "Stego Test",
            "redirect_uris": "stego://auth",
            "scopes": "read write follow",
            "website": "https://zeen.com"
        ]

        let routeInfo = RouteInfo(method: .post, path: basePath, parameters: params)
        return Api.call(routeInfo, completion: completion)

    }
}
