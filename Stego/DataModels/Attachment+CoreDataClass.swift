//
//  Attachment+CoreDataClass.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData

@objc(Attachment)
public class Attachment: NSManagedObject, Codable {
    
    private enum CodingKey: String, Swift.CodingKey {
        case id
        case type
        case url
        case remoteUrl = "remote_url"
        case previewUrl = "preview_url"
        case textUrl = "text_url"
        case description
        
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = (decoder.userInfo[databaseKey] as? Database)?.context as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Attachment", in: managedObjectContext) else {

                fatalError("No managed object context")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        remoteUrl = try container.decodeIfPresent(URL.self, forKey: .remoteUrl)
        previewUrl = try container.decodeIfPresent(URL.self, forKey: .previewUrl)
        textUrl = try container.decodeIfPresent(URL.self, forKey: .textUrl)
        attachmentDescription = try container.decodeIfPresent(String.self, forKey: .description)
        
    }
}
