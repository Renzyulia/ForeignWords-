//
//  NewWordModel.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 03.05.2023.
//

import UIKit
import CoreData

final class NewWordModel {
    weak var delegate: NewWordModelDelegate?
    var newWord: String? = nil
    var translation: String? = nil
    var context: String? = nil
    
    func viewDidLoad() {
        delegate?.showNewWordView()
    }
    
    private func checkRepeat(word: String) -> Bool {
        let savedWords = fetchData(CoreData.shared.viewContext)
        
        for savedWord in savedWords {
            if savedWord.word == word {
                delegate?.showRepeatWordError()
                return true
            }
        }
        return false
    }
    
    func didTapSaveButton() {
        guard let newWord = newWord, let translation = translation else { return }
        guard checkRepeat(word: newWord) == false else { return }
        
        let coreDataContext = CoreData.shared.viewContext
        let object = Words(context: coreDataContext)
        
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
        delegate?.notifyCompletion()
    }
    
    private func fetchData(_ context: NSManagedObjectContext) -> [Words] {
        var wordsData = [Words]()
        
        do {
            wordsData = try context.fetch(Words.fetchRequest())
        } catch {
            print("error") // показать алерт с ошибкой
        }
        
        return wordsData
    }
}
