//
//  Mention+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 21/08/18.
//
//

import Foundation
import CoreData


extension Mention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mention> {
        return NSFetchRequest<Mention>(entityName: "Mention")
    }

    @NSManaged public var url: URL?
    @NSManaged public var username: String?
    @NSManaged public var acct: String?
    @NSManaged public var id: String?
    @NSManaged public var status: Status?

}
