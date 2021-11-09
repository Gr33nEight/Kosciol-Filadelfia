//
//  Persistance.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 02/04/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container : NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Notes")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
}
