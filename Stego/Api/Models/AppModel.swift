//
//  AppModel.swift
//  Stego
//
//  Created by George Sealy on 14/08/18.
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
