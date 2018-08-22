//
//  AttachmentMeta+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 22/08/18.
//
//

import Foundation
import CoreData


extension AttachmentMeta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttachmentMeta> {
        return NSFetchRequest<AttachmentMeta>(entityName: "AttachmentMeta")
    }

    @NSManaged public var small: AttachmentMetaData?
    @NSManaged public var original: AttachmentMetaData?

}
