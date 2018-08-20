//
//  Database.swift
//  Stego
//
//  Created by George Sealy on 20/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

enum DatabaseStorageType {
    case memoryBased
    case fileBased
}

protocol Database {
    
    var context: Any? { get }
    
//    func createEntity<T: Codable & NSManagedObject>(entityName: String) throws -> T
    
    func save() throws
}

