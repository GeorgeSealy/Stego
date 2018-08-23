//
//  TestViewController.swift
//  Stego
//
//  Created by George Sealy on 23/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import UIKit
import CoreData

class TestViewController: UIViewController {
    
    @IBOutlet weak var testButton: UIButton!
    
    var coreDataManager: CoreDataManager?
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testButton.isEnabled = false
        coreDataManager = CoreDataManager(modelName: "TestModel", completion: {
            self.testButton.isEnabled = true
        })
    }


    @IBAction func testAction(_ sender: Any) {
        guard let context = coreDataManager?.mainManagedObjectContext else {
            fatalError()
        }
        
        counter += 1
        Log("\(type(of: self)) - \(#function): Test action")
            
        let testEntity = TestEntity(context: context)
        
        let id = (counter % 2 == 1) ? 1 : counter
        
        testEntity.id = "Id: \(id)"
        testEntity.content = "Counter \(counter)"
        
        let fetchRequest: NSFetchRequest<TestEntity> = TestEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == \"\(testEntity.id ?? "")\"")
        guard let databaseContext = coreDataManager?.mainManagedObjectContext else {
            fatalError("No context")
        }
        
        do {
        let results = try databaseContext.fetch(fetchRequest)
            
            for result in results {
                
                if result == testEntity {
                    Log("\(type(of: self)) - \(#function): got new entity, skipping")
                    continue
                }
                Log("\(type(of: self)) - \(#function): DELETIN: id \(result.id ?? "") content \(result.content ?? "")")
                context.delete(result)
            }
        } catch let error {
            Log("\(type(of: self)) - \(#function): UNIQUENESS FETCH ERROR: \(error)")

        }

//        if id == 1 {
//            let testEntity = TestEntity(context: context)
//            
//            let id = (counter % 2 == 1) ? 1 : counter
//            
//            testEntity.id = "Id: \(id)"
//            testEntity.content = "Counter \(counter)b"
//        }
        
        testFetch("Created")
        
        do {
            try context.save()
        } catch let error {
            Log("\(type(of: self)) - \(#function): SAVE ERROR: \(error)")
        }
        testFetch("Saved")

    }
    
    func testFetch(_ message: String) {
        do {
            let fetchRequest: NSFetchRequest<TestEntity> = TestEntity.fetchRequest()
            
            guard let databaseContext = coreDataManager?.mainManagedObjectContext else {
                fatalError("No context")
            }
            
            let results = try databaseContext.fetch(fetchRequest)
            
            Log("\(type(of: self)) - \(#function): <<< \(message) >>")
            Log("\(type(of: self)) - \(#function): database has: \(results.count)")
            
            for r in results {
                
                Log("\(type(of: self)) - \(#function):     id: \(r.id ?? "ID") content: \(r.content ?? "CONTENT")")
            }
            
        } catch let error {
            Log("\(type(of: self)) - \(#function): FETCH ERROR: \(error)")
        }

    }

}
