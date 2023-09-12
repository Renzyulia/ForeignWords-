//
//  CoreData.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 08.05.2023.
//

import UIKit
import CoreData

protocol Storage {
  var viewContext: NSManagedObjectContext { get }
}

final class CoreData: Storage {
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {}
}
