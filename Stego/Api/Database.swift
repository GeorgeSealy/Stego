//
//  Database.swift
//  Stego
//
//  Created by George Sealy on 20/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import CoreData

protocol Database {
    
    var context: Any? { get }
    
    func save() throws
}

class CoreDataDatabase: Database {
    
    var context: Any?

    func save() throws {
        guard let context = self.context as? NSManagedObjectContext else {
            fatalError("No context")
        }
        
        try context.save()
    }

    init() {
        // TODO: (George) option for kind of database (file vs in memory vs null bucket?)
        self.context = CoreDataDatabase.setUpInMemoryManagedObjectContext()
    }
    
    static func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Unable to load data models")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
