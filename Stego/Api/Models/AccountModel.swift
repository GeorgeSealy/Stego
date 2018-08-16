//
//  AccountModel.swift
//  Stego
//
//  Created by George Sealy on 15/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

struct AccountModel: Decodable {
    
    let id: String
    let username: String
    let acct: String
    let displayName: String

    enum CodingKey: String, Swift.CodingKey {
        case id
        case username
        case acct
        case displayName = "display_name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        acct = try container.decode(String.self, forKey: .acct)
        displayName = try container.decode(String.self, forKey: .displayName)
    }
}
