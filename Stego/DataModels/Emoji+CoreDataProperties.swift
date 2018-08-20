//
//  Emoji+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData


extension Emoji {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emoji> {
        return NSFetchRequest<Emoji>(entityName: "Emoji")
    }

    @NSManaged public var shortCode: String?
    @NSManaged public var staticUrl: URL?
    @NSManaged public var url: URL?
    @NSManaged public var visibleInPicker: Bool
    @NSManaged public var statuses: NSSet?

}

// MARK: Generated accessors for statuses
extension Emoji {

    @objc(addStatusesObject:)
    @NSManaged public func addToStatuses(_ value: Status)

    @objc(removeStatusesObject:)
    @NSManaged public func removeFromStatuses(_ value: Status)

    @objc(addStatuses:)
    @NSManaged public func addToStatuses(_ values: NSSet)

    @objc(removeStatuses:)
    @NSManaged public func removeFromStatuses(_ values: NSSet)

}
