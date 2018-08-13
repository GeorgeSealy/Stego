//
//  Oauth.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

class Oauth {
    
    static let basePath = "oauth"
    
    static func accessToken(clientId: String, clientSecret: String, code: String, redirectUri: String, completion: @escaping (_ apiResponse: Result<EmptyModel>) -> Void) -> ApiRequest {
        
        //            /oauth/token using a POST request with
        //            the parameters client_id=<client_key> (yes, this is confusing!),
        //            client_secret=<client_secret>,
        //            grant_type=refresh_token,
        //            refresh_token=<refresh_token>.
        //            Save the access_token you get back in your local cache
        let params: [String: Any] = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "redirect_uri": redirectUri,
            "grant_type": "authorization_code",
            "code": code
        ]
        
        var routeInfo = RouteInfo(method: .post, path: basePath + "/token", parameters: params)
        routeInfo.isApiCall = false
        
        return Api.call(routeInfo, completion: completion)
        
    }
}
