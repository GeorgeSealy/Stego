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
        case account
        case content
        case pinned
        case language
        case visibility
        case spoilerText = "spoiler_text"
        case sensitive
        case muted
        case favourited
        case reblogged
        case repliesCount = "replies_count"
        case reblogsCount = "reblogs_count"
        case favouritesCount = "favourites_count"
        case inReplyToId = "in_reply_to_id"
        case inReplyToAccountId = "in_reply_to_account_id"
        case uri
        case mediaAttachments = "media_attachments"
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
        account = try? container.decode(Account.self, forKey: .account)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        
        pinned = try container.decodeIfPresent(Bool.self, forKey: .pinned) ?? false
        language = try container.decodeIfPresent(String.self, forKey: .language)
        visibility = try container.decodeIfPresent(String.self, forKey: .visibility)
        spoilerText = try container.decodeIfPresent(String.self, forKey: .spoilerText)
        sensitive = try container.decodeIfPresent(Bool.self, forKey: .sensitive) ?? false
        muted = try container.decodeIfPresent(Bool.self, forKey: .muted) ?? false
        favourited = try container.decodeIfPresent(Bool.self, forKey: .favourited) ?? false
        reblogged = try container.decodeIfPresent(Bool.self, forKey: .reblogged) ?? false
        repliesCount = try container.decodeIfPresent(Int64.self, forKey: .repliesCount) ?? 0
        reblogsCount = try container.decodeIfPresent(Int64.self, forKey: .reblogsCount) ?? 0
        favouritesCount = try container.decodeIfPresent(Int64.self, forKey: .favouritesCount) ?? 0
        inReplyToId = try container.decodeIfPresent(String.self, forKey: .inReplyToId)
        inReplyToAccountId = try container.decodeIfPresent(String.self, forKey: .inReplyToAccountId)
        uri = try container.decodeIfPresent(URL.self, forKey: .uri)
        
        if let attachments = try container.decodeIfPresent([Attachment].self, forKey: .mediaAttachments) {
            mediaAttachments = NSSet(array: attachments)
        }
        
        if let count = mediaAttachments?.count, count > 0 {
            dump("STATUS WITH ATTACHMENTS")
        }
    }
    
    func dump(_ why: String) {
        Log("\(type(of: self)) - \(#function): \(why): ")
        Log("\(type(of: self)) - \(#function):   From: \(account?.displayName ?? "UNKNOWN")")
        Log("\(type(of: self)) - \(#function):   Content: \(content ?? "NO CONTENT")")
        Log("\(type(of: self)) - \(#function):   Attachments:")
        
        if let attachments = mediaAttachments {
            for attachment in attachments {
                
                guard let a = attachment as? Attachment else { continue }
                
                Log("\(type(of: self)) - \(#function):     type: \(a.type ?? "NO TYPE")")
                Log("\(type(of: self)) - \(#function):     url: \(String(describing: a.url))")
            }
        }
    }

//    reblog     null or the reblogged Status     yes
//    emojis     An array of Emoji     no
//    media_attachments     An array of Attachments     no
//    mentions     An array of Mentions     no
//    tags     An array of Tags     no
//    application     Application from which the status was posted     yes
}
