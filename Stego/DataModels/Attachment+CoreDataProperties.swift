//
//  Attachment+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData


extension Attachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment")
    }

    @NSManaged public var attachmentDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var previewUrl: URL?
    @NSManaged public var remoteUrl: URL?
    @NSManaged public var textUrl: URL?
    @NSManaged public var type: String?
    @NSManaged public var url: URL?
    @NSManaged public var status: Status?

}
