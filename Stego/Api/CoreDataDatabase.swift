//
//  CoreDataDatabase.swift
//  Stego
//
//  Created by George Sealy on 20/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataDatabase: Database {
    
    var context: Any?
    
    //    func createEntity<T: Codable & NSManagedObject>(entityName: String) throws -> T {
    //
    //        guard
    //            let managedObjectContext = self.context,
    //            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else {
    //
    //                fatalError("No managed object context")
    //
    //        }
    //
    //        return T.init(entity: entity, insertInto: managedObjectContext)
    //
    //    }
    
    func load() {
        
//        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
//            if let error = error {
//                print("Unable to Load Persistent Store")
//                print("\(error), \(error.localizedDescription)")
//
//            } else {
//                self.setupView()
//
//                do {
//                    try self.fetchedResultsController.performFetch()
//                } catch {
//                    let fetchError = error as NSError
//                    print("Unable to Perform Fetch Request")
//                    print("\(fetchError), \(fetchError.localizedDescription)")
//                }
//
//                self.updateView()
//            }
//        }
    }
    
    func save() throws {
        guard let context = self.context as? NSManagedObjectContext else {
            fatalError("No context")
        }
        
        try context.save()
    }
    
    init(storageType: DatabaseStorageType) {
        self.context = CoreDataDatabase.setUpManagedObjectContext(storageType)
    }
    
    static var applicationDocumentsDirectory: URL? = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last
    }()
    
    static func setUpManagedObjectContext(_ storageType: DatabaseStorageType) -> NSManagedObjectContext {
        
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Unable to load data models")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            switch storageType {
            case .memoryBased:
                try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
                
            case .fileBased:
                let url = self.applicationDocumentsDirectory?.appendingPathComponent("coreData.sqlite")
                
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            }
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
