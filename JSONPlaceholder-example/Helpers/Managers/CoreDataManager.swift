//
//  Persistence.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import CoreData

struct CoreDataManager {
    
    let container: NSPersistentContainer
    static let shared = CoreDataManager()

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "JSONPlaceholder_example")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
