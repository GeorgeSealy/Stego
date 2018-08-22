//
//  Accounts.swift
//  Stego
//
//  Created by George Sealy on 15/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

//        GET /api/v1/accounts/verify_credentials

enum Accounts: ApiEndpoint {
    
    case verifyCredentials
    
    var route: RouteInfo {
        
        let basePath = "accounts"
        
        let result: RouteInfo
        
        switch self {
        case .verifyCredentials:
            
            let params: [String: Any] = [:]
            
            result = RouteInfo(method: .get, path: "\(basePath)/verify_credentials", parameters: params)
        }
        
        return result
    }
    
    var resultType: Decodable.Type {
        
        switch self {
        case .verifyCredentials:
            return Account.self
        }
    }
    
    func preSave(_ result: Decodable) {}
}
