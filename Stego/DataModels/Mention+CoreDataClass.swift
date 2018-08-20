//
//  Mention+CoreDataClass.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData

@objc(Mention)
public class Mention: NSManagedObject, Codable {
    
    private enum CodingKey: String, Swift.CodingKey {
        case id
        case username
        case acct
        case url
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = (decoder.userInfo[databaseKey] as? Database)?.context as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Mention", in: managedObjectContext) else {
                
                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        acct = try container.decodeIfPresent(String.self, forKey: .acct)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        
    }
}
