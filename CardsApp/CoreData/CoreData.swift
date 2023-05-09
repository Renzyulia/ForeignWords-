//
//  CoreData.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 08.05.2023.
//

import UIKit
import CoreData

final class CoreData {
    static let shared = CoreData()
    
    var viewContext: NSManagedObjectContext { CoreData.shared.persistentContainer.viewContext }
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
}
