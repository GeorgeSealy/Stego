//
//  CoreDataManager.swift
//  Stego
//
//  Created by George Sealy on 23/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    typealias CoreDataManagerCompletion = () -> Void
    
    fileprivate let modelName: String
    fileprivate let completion: CoreDataManagerCompletion
    
    init(modelName: String, completion: @escaping CoreDataManagerCompletion) {
        self.modelName = modelName
        self.completion = completion
        
        setupCoreDataStack()
    }
    
    // MARK: - Core Data Stack
    
    fileprivate(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateManagedObjectContext

        setStandardContextOptions(managedObjectContext)


        return managedObjectContext
    }()
    
    fileprivate lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        setStandardContextOptions(managedObjectContext)

        return managedObjectContext
    }()
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            return nil
        }
        
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        
        return managedObjectModel
    }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = self.managedObjectModel else {
            return nil
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        return persistentStoreCoordinator
    }()
    
    // MARK: - Computed Properties
    
    fileprivate var persistentStoreURL: URL {
        // Helpers
        let storeName = "\(modelName).sqlite"
        let fileManager = FileManager.default
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documentsDirectoryURL.appendingPathComponent(storeName)
    }
    
    // MARK: - Helper Methods
    
    func saveChanges() {
        mainManagedObjectContext.performAndWait({
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
        })
        
        privateManagedObjectContext.perform({
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(saveError), \(saveError.localizedDescription)")
            }
        })
    }
    
    func workerManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = mainManagedObjectContext

        setStandardContextOptions(managedObjectContext)
        
        return managedObjectContext
    }
    
    // MARK: - Private Helper Methods
    
    fileprivate func setStandardContextOptions(_ managedObjectContext: NSManagedObjectContext) {
        
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.stalenessInterval = 0
        managedObjectContext.automaticallyMergesChangesFromParent = true
    }
    
    fileprivate func setupCoreDataStack() {
        let _ = mainManagedObjectContext.persistentStoreCoordinator
        
        DispatchQueue.global().async {
            self.addPersistentStore()
            
            DispatchQueue.main.async { self.completion() }
        }
    }
    
    fileprivate func addPersistentStore() {
        guard let persistentStoreCoordinator = persistentStoreCoordinator else { fatalError("Unable to Initialize Persistent Store Coordinator") }
        
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]

            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
//            let persistentStoreURL = self.persistentStoreURL
//            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)

        } catch {
            let addPersistentStoreError = error as NSError
            
            print("\(addPersistentStoreError.localizedDescription)")
        }
    }
    
}
