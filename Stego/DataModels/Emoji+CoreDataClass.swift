//
//  Emoji+CoreDataClass.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData

@objc(Emoji)
public class Emoji: NSManagedObject, Codable {

    private enum CodingKey: String, Swift.CodingKey {
        case shortCode = "short_code"
        case staticUrl = "static_url"
        case url
        case visibleInPicker = "visible_in_picker"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = decoder.userInfo[databaseKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Emoji", in: managedObjectContext) else {
                
                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        shortCode = try container.decodeIfPresent(String.self, forKey: .shortCode)
        staticUrl = try container.decodeIfPresent(URL.self, forKey: .staticUrl)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        visibleInPicker = try container.decodeIfPresent(Bool.self, forKey: .visibleInPicker) ?? false

    }
}
