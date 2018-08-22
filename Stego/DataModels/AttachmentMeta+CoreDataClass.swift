//
//  AttachmentMeta+CoreDataClass.swift
//  
//
//  Created by George Sealy on 22/08/18.
//
//

import Foundation
import CoreData

@objc(AttachmentMeta)
public class AttachmentMeta: NSManagedObject, Codable {
    
    private enum CodingKey: String, Swift.CodingKey {
        case small
        case original
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = (decoder.userInfo[databaseKey] as? Database)?.context as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "AttachmentMeta", in: managedObjectContext) else {
                
                fatalError("No managed object context")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        small = try container.decodeIfPresent(AttachmentMetaData.self, forKey: .small)
        original = try container.decodeIfPresent(AttachmentMetaData.self, forKey: .original)

    }

}
