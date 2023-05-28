//
//  NewWordModel.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 03.05.2023.
//

import UIKit
import CoreData

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
    
    func didTapSaveButton() {
        let coreDataContext = CoreData.shared.viewContext
        let object = Words(context: coreDataContext)
        
        guard let newWord = newWord, let translation = translation else { return }
        object.word = newWord
        object.translation = translation
        object.guess = 0
        object.date = nil
        object.lastShowTranslation = true
        object.showTranslation = 0
        object.showOriginal = 0
        
        if let context = context {
            object.context = context
        }
        
        do {
            try coreDataContext.save()
            delegate?.showNewWordView()
            
            self.newWord = nil
            self.translation = nil
            self.context = nil
        } catch {
            delegate?.showSavingError()
        }
    }
    
    func didTapBackButton() {
        delegate?.showMainPageView()
    }
    
    func didTapTrainingButton() {
        delegate?.showTrainingView()
    }
}
