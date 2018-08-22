//
//  Account+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 22/08/18.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var acct: String?
    @NSManaged public var avatar: URL?
    @NSManaged public var avatarStatic: URL?
    @NSManaged public var bot: Bool
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var displayName: String?
    @NSManaged public var followersCount: Int64
    @NSManaged public var followingCount: Int64
    @NSManaged public var header: URL?
    @NSManaged public var headerStatic: URL?
    @NSManaged public var id: String?
    @NSManaged public var locked: Bool
    @NSManaged public var moved: Bool
    @NSManaged public var note: String?
    @NSManaged public var statusesCount: Int64
    @NSManaged public var url: URL?
    @NSManaged public var username: String?
    @NSManaged public var statuses: NSOrderedSet?

}

// MARK: Generated accessors for statuses
extension Account {

    @objc(insertObject:inStatusesAtIndex:)
    @NSManaged public func insertIntoStatuses(_ value: Status, at idx: Int)

    @objc(removeObjectFromStatusesAtIndex:)
    @NSManaged public func removeFromStatuses(at idx: Int)

    @objc(insertStatuses:atIndexes:)
    @NSManaged public func insertIntoStatuses(_ values: [Status], at indexes: NSIndexSet)

    @objc(removeStatusesAtIndexes:)
    @NSManaged public func removeFromStatuses(at indexes: NSIndexSet)

    @objc(replaceObjectInStatusesAtIndex:withObject:)
    @NSManaged public func replaceStatuses(at idx: Int, with value: Status)

    @objc(replaceStatusesAtIndexes:withStatuses:)
    @NSManaged public func replaceStatuses(at indexes: NSIndexSet, with values: [Status])

    @objc(addStatusesObject:)
    @NSManaged public func addToStatuses(_ value: Status)

    @objc(removeStatusesObject:)
    @NSManaged public func removeFromStatuses(_ value: Status)

    @objc(addStatuses:)
    @NSManaged public func addToStatuses(_ values: NSOrderedSet)

    @objc(removeStatuses:)
    @NSManaged public func removeFromStatuses(_ values: NSOrderedSet)

}
