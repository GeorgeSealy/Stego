//
//  Status+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData


extension Status {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Status> {
        return NSFetchRequest<Status>(entityName: "Status")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var url: URL?
    @NSManaged public var pinned: Bool
    @NSManaged public var language: String?
    @NSManaged public var visibility: String?
    @NSManaged public var spoilerText: String?
    @NSManaged public var sensitive: Bool
    @NSManaged public var muted: Bool
    @NSManaged public var favourited: Bool
    @NSManaged public var reblogged: Bool
    @NSManaged public var repliesCount: Int64
    @NSManaged public var reblogsCount: Int64
    @NSManaged public var favouritesCount: Int64
    @NSManaged public var inReplyToId: String?
    @NSManaged public var inReplyToAccountId: String?
    @NSManaged public var uri: URL?
    @NSManaged public var account: Account?
    @NSManaged public var mediaAttachments: NSSet?
    @NSManaged public var reblog: Status?
    @NSManaged public var reblogs: NSSet?
    @NSManaged public var emoji: NSSet?
    @NSManaged public var mentions: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for mediaAttachments
extension Status {

    @objc(addMediaAttachmentsObject:)
    @NSManaged public func addToMediaAttachments(_ value: Attachment)

    @objc(removeMediaAttachmentsObject:)
    @NSManaged public func removeFromMediaAttachments(_ value: Attachment)

    @objc(addMediaAttachments:)
    @NSManaged public func addToMediaAttachments(_ values: NSSet)

    @objc(removeMediaAttachments:)
    @NSManaged public func removeFromMediaAttachments(_ values: NSSet)

}

// MARK: Generated accessors for reblogs
extension Status {

    @objc(addReblogsObject:)
    @NSManaged public func addToReblogs(_ value: Status)

    @objc(removeReblogsObject:)
    @NSManaged public func removeFromReblogs(_ value: Status)

    @objc(addReblogs:)
    @NSManaged public func addToReblogs(_ values: NSSet)

    @objc(removeReblogs:)
    @NSManaged public func removeFromReblogs(_ values: NSSet)

}

// MARK: Generated accessors for emoji
extension Status {

    @objc(addEmojiObject:)
    @NSManaged public func addToEmoji(_ value: Emoji)

    @objc(removeEmojiObject:)
    @NSManaged public func removeFromEmoji(_ value: Emoji)

    @objc(addEmoji:)
    @NSManaged public func addToEmoji(_ values: NSSet)

    @objc(removeEmoji:)
    @NSManaged public func removeFromEmoji(_ values: NSSet)

}

// MARK: Generated accessors for mentions
extension Status {

    @objc(addMentionsObject:)
    @NSManaged public func addToMentions(_ value: Mention)

    @objc(removeMentionsObject:)
    @NSManaged public func removeFromMentions(_ value: Mention)

    @objc(addMentions:)
    @NSManaged public func addToMentions(_ values: NSSet)

    @objc(removeMentions:)
    @NSManaged public func removeFromMentions(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Status {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
