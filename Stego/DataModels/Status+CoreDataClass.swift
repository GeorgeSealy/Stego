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
        case reblog
        case emojis
        case mentions
        case tags
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
        
        reblog = try? container.decode(Status.self, forKey: .reblog)

        if let attachmentArray = try container.decodeIfPresent([Attachment].self, forKey: .mediaAttachments) {
            mediaAttachments = NSSet(array: attachmentArray)
        }
        
        if let emojiArray = try container.decodeIfPresent([Emoji].self, forKey: .emojis) {
            emoji = NSSet(array: emojiArray)
        }
        
        if let mentionsArray = try container.decodeIfPresent([Mention].self, forKey: .mentions) {
            mentions = NSSet(array: mentionsArray)
        }
        
        if let tagsArray = try container.decodeIfPresent([Tag].self, forKey: .tags) {
            tags = NSSet(array: tagsArray)
        }
        
//        let hasAttachments = (mediaAttachments?.count ?? 0) > 0
//        let hasMentions = (mentions?.count ?? 0) > 0
//        let hasEmoji = (emoji?.count ?? 0) > 0
//        let hasTags = (tags?.count ?? 0) > 0
//        let hasReblog = reblog != nil
        
//        if hasAttachments || hasMentions || hasEmoji || hasTags || hasReblog {
//
//            var things = ""
//
//            things += hasAttachments ? "Attachments: " : ""
//            things += hasMentions ? "Mentions: " : ""
//            things += hasEmoji ? "Emoji: " : ""
//            things += hasTags ? "Tags: " : ""
//            things += hasReblog ? "Reblog: " : ""
//
//            dump("STATUS WITH \(things)")
//        }
    }
    
    func dump(_ why: String) {
        Log("\(type(of: self)) - \(#function): \(why) ")
        Log("\(type(of: self)) - \(#function):   From: \(account?.displayName ?? "UNKNOWN")")
        Log("\(type(of: self)) - \(#function):   Content: \(content ?? "NO CONTENT")")
        
        Log("\(type(of: self)) - \(#function):   Reblog:")
        
        if let r = reblog {
            Log("\(type(of: self)) - \(#function):     From: \(r.account?.displayName ?? "UNKNOWN")")
            Log("\(type(of: self)) - \(#function):     Content: \(r.content ?? "NO CONTENT")")
        }

        Log("\(type(of: self)) - \(#function):   Attachments:")
        
        if let attachments = mediaAttachments {
            for attachment in attachments {
                
                guard let a = attachment as? Attachment else { continue }
                
                Log("\(type(of: self)) - \(#function):     type: \(a.type ?? "NO TYPE")")
                Log("\(type(of: self)) - \(#function):     url: \(String(describing: a.url))")
            }
        }
        
        Log("\(type(of: self)) - \(#function):   Mentions:")
        
        if let mentions = mentions {
            for mention in mentions {
                
                guard let m = mention as? Mention else { continue }
                
                Log("\(type(of: self)) - \(#function):     user: \(m.username ?? "NO USER")")
            }
        }
        
        Log("\(type(of: self)) - \(#function):   Emoji:")
        
        if let emoji = emoji {
            for singleEmoji in emoji {
                
                guard let e = singleEmoji as? Emoji else { continue }
                
                Log("\(type(of: self)) - \(#function):     code: \(e.shortCode ?? "NO SHORT CODE")")
            }
        }
        
        Log("\(type(of: self)) - \(#function):   Tags:")
        
        if let tags = tags {
            for tag in tags {
                
                guard let t = tag as? Tag else { continue }
                
                Log("\(type(of: self)) - \(#function):     tag: \(t.name ?? "NO NAME")")
            }
        }
    }

//    application     Application from which the status was posted     yes
}
