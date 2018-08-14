//
//  Oauth.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

enum Oauth {
    
    case accessToken(clientId: String, clientSecret: String, code: String, redirectUri: String)
    
    var route: RouteInfo {
    
        let basePath = "oauth"
        
        var result: RouteInfo
        
        switch self {
        case .accessToken(let clientId, let clientSecret, let code, let redirectUri):
            
            let params: [String: Any] = [
                "client_id": clientId,
                "client_secret": clientSecret,
                "redirect_uri": redirectUri,
                "grant_type": "authorization_code",
                "code": code
            ]
            
            result = RouteInfo(method: .post, path: basePath + "/token", parameters: params)
            result.isApiCall = false
        }
        
        return result
    }

}

