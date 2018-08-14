//
//  ApiError.swift
//  Stego
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

struct ApiError: Decodable {
    let error: String
    let description: String
    
    
    enum CodingKey: String, Swift.CodingKey {
        case error
        case description = "error_description"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        self.error = try container.decode(String.self, forKey: .error)
        self.description = try container.decode(String.self, forKey: .description)
        
    }

}
