//
//  Status+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 20/08/18.
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
    @NSManaged public var account: Account?

}
