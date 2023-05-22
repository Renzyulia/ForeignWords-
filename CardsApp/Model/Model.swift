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
    
    private var trainingWords = Set<String>()
    
    func viewDidLoad() {
        delegate?.showMainPageView()
    }
    
    func didTapNewWordButton() {
        delegate?.showNewWordView()
    }
    
    func didTapTrainingButton() {
        let coreDataContext = CoreData.shared.viewContext
        let savedWords = fetchData(coreDataContext)
        
        trainingWords = formTrainingWords(from: savedWords)
        
        guard !trainingWords.isEmpty else {
            delegate?.showNoSavedWordsError()
            return
        }
        
        let displayedWord = trainingWords.removeFirst()
        var displayedWordWithDetails: Words? = nil
        
        for savedWord in savedWords {
            if savedWord.word == displayedWord || savedWord.translation == displayedWord {
                displayedWordWithDetails = savedWord
                break
            }
        }
        guard let trainingWord = displayedWordWithDetails else { return } //здесь нужно ошибку какую-то выдать?
        delegate?.showTrainingView(for: trainingWord.word, translation: trainingWord.translation, context: trainingWord.context ?? "")
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
    
    func didTapOnTrainingView() {
        delegate?.showWordDetailsView()
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
    
    private func formTrainingWords(from words: [Words]) -> Set<String> {
        var trainingWords = Set<String>()
        var unknownWords = 0
        var littleKnownWords = 0
        var knownWords = 0
        var translations = [Words]()
        var originalWords = [Words]()

        //добавляем слова в массив слов
        for word in words {
            if check(of: word) {
                if word.guess <= 3 && unknownWords <= 6 {
                    if word.lastShowTranslation {
                        originalWords.append(word)
                    } else {
                        translations.append(word)
                    }
                    unknownWords += 1
                } else if word.guess > 3 && word.guess <= 17 && littleKnownWords <= 18 {
                    if word.lastShowTranslation {
                        originalWords.append(word)
                    } else {
                        translations.append(word)
                    }
                    littleKnownWords += 1
                } else if word.guess > 17 && word.guess <= 25 && knownWords <= 6 {
                    if word.lastShowTranslation {
                        originalWords.append(word)
                    } else {
                        translations.append(word)
                    }
                    knownWords += 1
                }
            }
        }
        
        // проверяем достаточное ли количество известных слов, если нет, то сначала добавляем из малоизвестных, потом из неизвестных
        if knownWords != 6 {
            var requiredBalance = 6 - knownWords
            for word in words {
                if requiredBalance != 0 {
                    if check(of: word) {
                        if word.guess > 3 && word.guess <= 17 {
                            guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                            if word.lastShowTranslation {
                                originalWords.append(word)
                            } else {
                                translations.append(word)
                            }
                            requiredBalance -= 1
                        }
                    }
                }
            }
            if requiredBalance != 0 {
                for word in words {
                    if requiredBalance != 0 {
                        if check(of: word) {
                            if word.guess <= 3 {
                                guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                                if word.lastShowTranslation {
                                    originalWords.append(word)
                                } else {
                                    translations.append(word)
                                }
                                requiredBalance -= 1
                            }
                        }
                    }
                }
            }
        }
        
    //    // проверяем достаточное ли количество неизвестных слов, если нет, то сначала добавляем из малоизвестных, потом из известных
        if unknownWords != 6 {
            var requiredBalance = 6 - unknownWords
            for word in words {
                if requiredBalance != 0 {
                    if check(of: word) {
                        if word.guess > 3 && word.guess <= 17 {
                            guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                            if word.lastShowTranslation {
                                originalWords.append(word)
                            } else {
                                translations.append(word)
                            }
                            requiredBalance -= 1
                        }
                    }
                }
            }
            if requiredBalance != 0 {
                for word in words {
                    if requiredBalance != 0 {
                        if check(of: word) {
                            if word.guess > 17 && word.guess <= 25 {
                                guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                                if word.lastShowTranslation {
                                    originalWords.append(word)
                                } else {
                                    translations.append(word)
                                }
                                requiredBalance -= 1
                            }
                        }
                    }
                }
            }
            
            if littleKnownWords != 6 {
                var requiredBalance = 6 - littleKnownWords
                for word in words {
                    if requiredBalance != 0 {
                        if check(of: word) {
                            if word.guess <= 3 {
                                guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                                if word.lastShowTranslation {
                                    originalWords.append(word)
                                } else {
                                    translations.append(word)
                                }
                                requiredBalance -= 1
                            }
                        }
                    }
                }
                if requiredBalance != 0 {
                    for word in words {
                        if requiredBalance != 0 {
                            if check(of: word) {
                                if word.guess > 17 && word.guess <= 25 {
                                    guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                                    if word.lastShowTranslation {
                                        originalWords.append(word)
                                    } else {
                                        translations.append(word)
                                    }
                                    requiredBalance -= 1
                                }
                            }
                        }
                    }
                }
            }
        }
        
    // проверяем баланс переводов и оригинальных слов в массивe
        let normalBalance = Int(Double(originalWords.count + translations.count) * 0.6)
        if originalWords.count < normalBalance {
            var requiredBalance = normalBalance - originalWords.count
            var sortedTranslations = translations.sorted(by: { (word1, word2) -> Bool in
                return word1.showTranslation > word2.showTranslation
            })
            
            while requiredBalance != 0 {
                let word = sortedTranslations.removeFirst()
                originalWords.append(word)
                requiredBalance -= 1
                
                for index in 0..<translations.count {
                    if translations[index] == word {
                        translations.remove(at: index)
                        break
                    }
                }
            }
        } else if originalWords.count > normalBalance {
            var requiredBalance = originalWords.count - normalBalance
            var sortedOriginalWords = originalWords.sorted(by: { (word1, word2) -> Bool in
                return word1.showOriginal > word2.showOriginal
            })
            while requiredBalance != 0 {
                let word = sortedOriginalWords.removeFirst()
                translations.append(word)
                requiredBalance -= 1
                
                for index in 0..<originalWords.count {
                    if originalWords[index] == word {
                        originalWords.remove(at: index)
                        break
                    }
                }
            }
        }
        
        for word in translations {
            trainingWords.insert(word.translation)
        }
        
        for word in originalWords {
            trainingWords.insert(word.word)
        }
        
        return trainingWords
    }
    
    private func check(of word: Words) -> Bool {
        if word.guess <= 3 {
            guard word.date != nil else { return true }
            let wordDate = word.date?.componentize()
            let todayDate = Date().componentize()
            if (wordDate?.day == todayDate.day && wordDate?.month == todayDate.month && wordDate?.year == todayDate.year) {
                return true
            }
        }
        
        if word.guess > 3 && word.guess <= 8 {
            var minDate: Date {
                return Calendar.current.date(byAdding: .day, value: 2, to: word.date!)!
            }
            var maxDate: Date {
                return Calendar.current.date(byAdding: .day, value: 5, to: word.date!)!
            }
            if Date().isBetween(minDate, maxDate) {
                return true
            } else if Date() > maxDate {
                // вызываем у слова изменение количества успешных показов на 2
                return true
            }
        }
        
        if word.guess > 8 && word.guess <= 12 {
            var minDate: Date {
                return Calendar.current.date(byAdding: .day, value: 3, to: word.date!)!
            }
            var maxDate: Date {
                return Calendar.current.date(byAdding: .day, value: 6, to: word.date!)!
            }
            if Date().isBetween(minDate, maxDate) {
                return true
            } else if Date() > maxDate {
                // вызываем у слова изменение количества успешных показов на 2
                return true
            }
        }
        
        if word.guess > 12 && word.guess <= 17 {
            var minDate: Date {
                return Calendar.current.date(byAdding: .day, value: 7, to: word.date!)!
            }
            var maxDate: Date {
                return Calendar.current.date(byAdding: .day, value: 10, to: word.date!)!
            }
            if Date().isBetween(minDate, maxDate) {
                return true
            } else if Date() > maxDate {
                // вызываем у слова изменение количества успешных показов на 2
                return true
            }
        }
        
        if word.guess > 17 && word.guess <= 21 {
            var minDate: Date {
                return Calendar.current.date(byAdding: .day, value: 15, to: word.date!)!
            }
            var maxDate: Date {
                return Calendar.current.date(byAdding: .day, value: 18, to: word.date!)!
            }
            if Date().isBetween(minDate, maxDate) {
                return true
            } else if Date() > maxDate {
                return true
            }
        }
        
        if word.guess > 21 && word.guess <= 25 {
            var minDate: Date {
                return Calendar.current.date(byAdding: .day, value: 30, to: word.date!)!
            }
            var maxDate: Date {
                return Calendar.current.date(byAdding: .day, value: 34, to: word.date!)!
            }
            if Date().isBetween(minDate, maxDate) {
                return true
            } else if Date() > maxDate {
                return true
            }
        }
        return false
    }
}
