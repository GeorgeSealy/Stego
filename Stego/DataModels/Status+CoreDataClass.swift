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
    static let databaseKey = CodingUserInfoKey(rawValue: "databaseKey")
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
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = (decoder.userInfo[databaseKey] as? Database)?.context as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Status", in: managedObjectContext) else {
                
                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)

        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        
        if
            let createdAtTimestamp = try container.decodeIfPresent(String.self, forKey: .createdAt),
            let timestamp = TimeInterval(createdAtTimestamp) {
            createdAt = NSDate(timeIntervalSince1970: timestamp)
        }
        
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        //        account = try? container.decode(AccountModel.self, forKey: .account)
        content = try container.decodeIfPresent(String.self, forKey: .content)
    }

}
