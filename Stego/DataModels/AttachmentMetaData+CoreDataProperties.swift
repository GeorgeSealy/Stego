//
//  AttachmentMetaData+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 22/08/18.
//
//

import Foundation
import CoreData


extension AttachmentMetaData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttachmentMetaData> {
        return NSFetchRequest<AttachmentMetaData>(entityName: "AttachmentMetaData")
    }

    @NSManaged public var aspect: Double
    @NSManaged public var width: Int64
    @NSManaged public var height: Int64
    @NSManaged public var size: String?

}
