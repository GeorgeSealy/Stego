//
//  Tag+CoreDataClass.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject, Codable {
    
    private enum CodingKey: String, Swift.CodingKey {
        case name
        case url
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = (decoder.userInfo[databaseKey] as? Database)?.context as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Tag", in: managedObjectContext) else {
                
                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        
    }
}
