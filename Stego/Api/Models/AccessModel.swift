//
//  AccessModel.swift
//  Stego
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

//"access_token":"eda215064987f34c6494f227cd1813b0d7d538541441e30fe22c7c33f39f1a52",
//"token_type":"bearer",
//"scope":"read write follow",
//"created_at":1534196895

//public enum DecodingError: Error {
//
//    case jsonDecodingFailed
//
//}

struct AccessModel: Decodable {
    
    let accessToken: String
    let createdAt: Date
    let tokenType: TokenType
    let scope: [ScopeType]

    enum TokenType: String {
        case bearer = "bearer"
        case mac = "mac"
    }
    
    enum ScopeType: String {
        case read = "read"
        case write = "write"
        case follow = "follow"
    }
    
    enum CodingKey: String, Swift.CodingKey {
        case accessToken = "access_token"
        case createdAt = "created_at"
        case tokenType = "token_type"
        case scope = "scope"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        
        let tokenTypeString = try container.decode(String.self, forKey: .tokenType)
        
        if let token = TokenType(rawValue: tokenTypeString.lowercased()) {
            tokenType = token
        } else {
            tokenType = .bearer
        }
        
        var scopes: [ScopeType] = []
        
        let scopeString = try container.decode(String.self, forKey: .scope)
        let individualScopes = scopeString.split(separator: " ")
        
        for individual in individualScopes {
            scopes.append(ScopeType(rawValue: String(individual))!)
        }
        
        scope = scopes
    }
}

