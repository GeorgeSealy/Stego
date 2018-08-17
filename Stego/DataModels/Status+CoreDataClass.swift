//
//  Status+CoreDataClass.swift
//  
//
//  Created by George Sealy on 17/08/18.
//
//

import Foundation
import CoreData

@objc(Status)
public class Status: NSManagedObject {
}

public extension Status: Decodable {
    private enum CodingKey: String, Swift.CodingKey {
        case id
        case createdAt = "created_at"
        case url
        //        case account
        case content
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        
        url = try container.decode(URL.self, forKey: .content)
        //        account = try? container.decode(AccountModel.self, forKey: .account)
        content = try container.decode(String.self, forKey: .content)
    }

}
