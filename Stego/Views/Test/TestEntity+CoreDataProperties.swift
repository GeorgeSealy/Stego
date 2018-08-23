//
//  TestEntity+CoreDataProperties.swift
//  
//
//  Created by George Sealy on 23/08/18.
//
//

import Foundation
import CoreData


extension TestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        return NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var content: String?

}
