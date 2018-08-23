//
//  Status+CoreDataClass.swift
//  
//
//  Created by George Sealy on 17/08/18.
//
//

import Foundation
import CoreData
import SwiftSoup

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
    
    func recurseDocument(_ element: Element, level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        
        Log("\(type(of: self)) - \(#function): \(indent){")

        Log("\(type(of: self)) - \(#function): \(indent)\(type(of: element)) class: \(try? element.className())")

        for child in element.children() {
            recurseDocument(child, level: level + 1)
        }
        
        Log("\(type(of: self)) - \(#function): \(indent)}")
    }
    
//    var internalAttributedContent: NSAttributedString?
    var attributedContent: NSAttributedString {
        
        //        guard let result = internalAttributedContent else {
        
        let html = content ?? ""
        let text: String
        
        //            let html: String = "<p>An <a href='http://example.com/'><b>example</b></a> link.</p>";
        do {
            let doc: Document = try SwiftSoup.parse(html)
//            if let body = doc.body() {
//                recurseDocument(body)
//            }
            //            let link: Element = try doc.select("a").first()!
            //
            text = try doc.body()!.text(); // "An example link"
//            Log("\(type(of: self)) - \(#function): TEXT: \(text)")
            //            let linkHref: String = try link.attr("href"); // "http://example.com/"
            //            let linkText: String = try link.text(); // "example""
            //
            //            let linkOuterH: String = try link.outerHtml(); // "<a href="http://example.com"><b>example</b></a>"
            //            let linkInnerH: String = try link.html(); // "<b>example</b>"
        } catch Exception.Error(let errorType, let message) {
            text = html
            Log("\(type(of: self)) - \(#function): \(message)")
        } catch let error {
            text = html
            Log("\(type(of: self)) - \(#function): error: \(error)")
        }
        
        //            let result = initialContent.parseMastodonHtml()
        let result = NSMutableAttributedString(string: text)
        
        //            internalAttributedContent = result
        return result
        //        }
        //
        //        return result
    }
    
    static var initCount = 0
    
    required convenience public init(from decoder: Decoder) throws {
        
        Status.initCount += 1
        Log("Status - \(#function): Create count: \(Status.initCount)")
        
        guard let databaseKey = CodingUserInfoKey.databaseKey,
            let managedObjectContext = decoder.userInfo[databaseKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Status", in: managedObjectContext) else {

                fatalError("No managed object context")
                
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)

        
        let container = try decoder.container(keyedBy: CodingKey.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)

//        Log("\(type(of: self)) - \(#function): TIMESTAMP \(String(describing: try? container.decodeIfPresent(String.self, forKey: .createdAt)))")

        if
            let createdAtTimestamp = try container.decodeIfPresent(String.self, forKey: .createdAt),
            let date = Api.dateFormatter.date(from: createdAtTimestamp) {
            createdAt = date as NSDate
        } else {
            createdAt = NSDate(timeIntervalSince1970: 0)
            Log("\(type(of: self)) - \(#function): BAD, BAD timestamp")
        }
        
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        account = try container.decodeIfPresent(Account.self, forKey: .account)
        
//        Log("\(type(of: self)) - \(#function): CONTENT: \(String(describing: try? container.decodeIfPresent(String.self, forKey: .content)))")

        content = try container.decodeIfPresent(String.self, forKey: .content)
        
        if content == nil {
            Log("\(type(of: self)) - \(#function): BAD CONTENT: \(String(describing: try? container.decodeIfPresent(String.self, forKey: .content)))")
            content = "BADLY PARSED CONTENT"
        }
        
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
        
        if let attemptedReblog = try? container.decodeIfPresent(Status.self, forKey: .reblog) {
            Log("\(type(of: self)) - \(#function): REBLOGGED: \(String(describing: attemptedReblog))")
            reblog = attemptedReblog
        } else {
            Log("\(type(of: self)) - \(#function): No REBLOG")
        }
//        Log("\(type(of: self)) - \(#function): REBLOG: \(try? container.decode(String.self, forKey: .reblog))")
//        reblog = try? container.decode(Status.self, forKey: .reblog)
//
//        if let r = reblog {
//            Log("\(type(of: self)) - \(#function): REBLOG: \(r)")
//            r.reblogParent = self
//        }

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

    }

//    application     Application from which the status was posted     yes
}
