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
