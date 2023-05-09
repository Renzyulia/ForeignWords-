//
//  NewWordModel.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 03.05.2023.
//

import UIKit

enum ProficiencyLevels: String {
    case unknownWord = "Unknown word"
    case littleKnownWord = "Little known word"
    case knownWord = "Known word"
}

final class Model {
    weak var delegate: ModelDelegate?
    
    var newWord: String? = nil
    var translation: String? = nil
    var context: String? = nil
    
    func viewDidLoad() {
        delegate?.showMainPageView()
    }
    
    func didTapNewWordButton() {
        delegate?.showNewWordView()
    }
    
    func didTapTrainingButton() {
        delegate?.showTrainingView()
    }
    
    func didTapSaveButton() {
        let coreDataContext = CoreData.shared.viewContext
        let object = Words(context: coreDataContext)
        
        guard let newWord = newWord, let translation = translation else { return }
        object.newWord = newWord
        object.translation = translation
        object.proficiencyLevel = ProficiencyLevels.unknownWord.rawValue
        
        if let context = context {
            object.context = context
        }
        
        do {
            try coreDataContext.save()
            delegate?.showNewWordView()
        } catch {
            delegate?.showSavingError()
        }
    }
    
    func didTapBackButton() {
        delegate?.showMainPageView()
    }
}
