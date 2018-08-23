//
//  AttachmentMetaData+CoreDataClass.swift
//  
//
//  Created by George Sealy on 22/08/18.
//
//

import Foundation
import CoreData

@objc(AttachmentMetaData)
public class AttachmentMetaData: NSManagedObject, Codable {
    
    private enum CodingKey: String, Swift.CodingKey {
        case aspect
        case width
        case height
        case size
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = decoder.userInfo[databaseKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "AttachmentMetaData", in: managedObjectContext) else {
                
                fatalError("No managed object context")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        aspect = try container.decodeIfPresent(Double.self, forKey: .aspect) ?? 1.0
        width = try container.decodeIfPresent(Int64.self, forKey: .width) ?? 10
        height = try container.decodeIfPresent(Int64.self, forKey: .height) ?? 10
        size = try container.decodeIfPresent(String.self, forKey: .size)
        
    }

}
