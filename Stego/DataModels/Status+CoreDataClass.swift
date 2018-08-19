//
//  Status+CoreDataClass.swift
//  
//
//  Created by George Sealy on 17/08/18.
//
//

import Foundation
import CoreData

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

@objc(Status)
public class Status: NSManagedObject, Codable {

    private enum CodingKey: String, Swift.CodingKey {
        case id
        case createdAt = "created_at"
        case url
        //        case account
        case content
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
                
                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        
        if let createdAtTimestamp = try container.decodeIfPresent(Int.self, forKey: .createdAt) {
            createdAt = NSDate(timeIntervalSince1970: TimeInterval(createdAtTimestamp))
        }
        
        url = try container.decodeIfPresent(URL.self, forKey: .content)
        //        account = try? container.decode(AccountModel.self, forKey: .account)
        content = try container.decodeIfPresent(String.self, forKey: .content)
    }

}
