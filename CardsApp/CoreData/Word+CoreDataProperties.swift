//
//  Word+CoreDataProperties.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 08.05.2023.
//
//

import Foundation
import CoreData

extension Words {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Words> {
        return NSFetchRequest<Words>(entityName: "Words")
    }

    @NSManaged public var newWord: String
    @NSManaged public var translation: String
    @NSManaged public var context: String?
    @NSManaged public var proficiencyLevel: String
}
