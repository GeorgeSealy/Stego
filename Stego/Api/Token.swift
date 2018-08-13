//
//  Token.swift
//  Stego
//
//  Created by George Sealy on 13/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

//struct TokenModel: Decodable {
//    let clientId: String
//    
//    enum CodingKey: String, Swift.CodingKey {
//        case clientId = "client_id"
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKey.self)
//        
//        clientId = try container.decode(String.self, forKey: .clientId)
//    }
//}
//
//// POST /api/v1/oauth/token
//
//class Apps {
//    
//    static let basePath = "oauth"
//    
//    static func get(_ completion: @escaping (_ apiResponse: Result<TokenModel>) -> Void) -> ApiRequest {
//        
//        let params: [String: Any] = [
//            "client_name": "Stego Test",
//            "redirect_uris": "urn:ietf:wg:oauth:2.0:oob"
//        ]
//        
//        let routeInfo = RouteInfo(method: .post, path: basePath, parameters: params)
//        return Api.call(routeInfo, completion: completion)
//        
//    }
//}
