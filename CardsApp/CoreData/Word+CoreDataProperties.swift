//
//  Word+CoreDataProperties.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 08.05.2023.
//
//

import Foundation
import CoreData

extension Word {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var newWord: String
    @NSManaged public var translation: String
    @NSManaged public var context: String?
}
