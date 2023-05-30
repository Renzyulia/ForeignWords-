//
//  TrainingModel.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 25.05.2023.
//

import UIKit
import CoreData

struct Guess {
    var numberGuess: Int
    
    var isUnknown: Bool {
        return numberGuess <= 3
    }
    var isLittleKnown: Bool {
        return numberGuess > 3 && numberGuess <= 17
    }
    
    var isKnown: Bool {
        return numberGuess > 17 && numberGuess <= 25
    }
}

enum WordsStatus {
    case unknown
    case littleUnknown
    case known
}

final class TrainingModel {
    weak var delegate: TrainingModelDelegate?
    
    private let coreDataContext = CoreData.shared.viewContext
    private var savedWords: [Words] {
        return fetchData(coreDataContext)
    }
    private var trainingWords = Set<String>()
    private var trainingWord: Words? = nil
    private var lastShowWordTranslation: Bool? = nil
    private var unknownWords = 0
    private var littleKnownWords = 0
    private var knownWords = 0
    private var translations = [Words]()
    private var originalWords = [Words]()
    
    func viewDidLoad() {
        trainingWords = formTrainingWords(from: savedWords)

        if trainingWords.isEmpty && savedWords.isEmpty {
            delegate?.showNoSavedWordsError()
        } else if trainingWords.isEmpty && !savedWords.isEmpty {
            delegate?.showNoTodayTrainingWords()
        } else {
            showTrainingWord()
        }
    }
    
    func didTapOnTrainingView() {
        delegate?.showWordDetailsView()
    }
    
    func didTapBackButton() {
        delegate?.notifyCompletion()
    }
    
    func didTapKnownWordButton() {
        guard let word = trainingWord else { return }
        guard let lastShowTranslation = lastShowWordTranslation else { return }
        
        do {
            word.guess += 1
            word.date = Date()
            word.lastShowTranslation = lastShowTranslation
            
            if lastShowTranslation {
                word.showTranslation += 1
            } else {
                word.showOriginal += 1
            }
            
            if word.guess > 25 {
                coreDataContext.delete(word)
            }
            
            try coreDataContext.save()
            
            trainingWord = nil
            lastShowWordTranslation = nil
            
            guard !trainingWords.isEmpty else {
                delegate?.showFinishTraining()
                return
            }
            showTrainingWord()
        } catch {
            delegate?.showSavingChangesError()
        }
    }
    
    func didTapUnknownWordButton() {
        guard let word = trainingWord else { return }
        guard let lastShowTranslation = lastShowWordTranslation else { return }
        
        do {
            word.date = Date()
            word.lastShowTranslation = lastShowTranslation
            
            if lastShowTranslation {
                word.showTranslation += 1
            } else {
                word.showOriginal += 1
            }
            
            try coreDataContext.save()
            
            trainingWord = nil
            lastShowWordTranslation = nil
            
            guard !trainingWords.isEmpty else {
                delegate?.showFinishTraining()
                return
            }
            showTrainingWord()
        } catch {
            delegate?.showSavingChangesError()
        }
    }
    
    private func showTrainingWord() {
        let displayedWord = trainingWords.removeFirst()
        var displayedWordWithDetails: Words? = nil
        
        for word in savedWords {
            if word.word == displayedWord || word.translation == displayedWord {
                displayedWordWithDetails = word
                break
            }
        }
        
        print(trainingWords)
        print(savedWords)

        guard let trainingWord = displayedWordWithDetails else { return } //здесь нужно ошибку какую-то выдать?

        // ставим флажок как показывается слово: перевод или оригинал
        if displayedWord == trainingWord.word {
            lastShowWordTranslation = false
        } else if displayedWord == trainingWord.translation {
            lastShowWordTranslation = true
        }
        
        self.trainingWord = trainingWord
        
        delegate?.showTrainingView(for: trainingWord.word, translation: trainingWord.translation, context: trainingWord.context ?? "", showTranslation: lastShowWordTranslation!)
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
    
    private func addTrainingWords(from savedWords: [Words]) {
        for word in savedWords {
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
    }
    
    private func configureWord(with status: WordsStatus) -> Words? { //тут нужно еще научить вовзращать nil
        switch status {
        case .known:
            for word in savedWords {
                if check(of: word) {
                    let wordGuess = Guess(numberGuess: word.guess)
                    if wordGuess.isKnown {
                        guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                        return word
                    }
                }
            }
            return nil
            
        case .littleUnknown:
            for word in savedWords {
                if check(of: word) {
                    let wordGuess = Guess(numberGuess: word.guess)
                    if wordGuess.isLittleKnown {
                        guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                        return word
                    }
                }
            }
            return nil
        case .unknown:
            for word in savedWords {
                if check(of: word) {
                    let wordGuess = Guess(numberGuess: word.guess)
                    if wordGuess.isUnknown {
                        guard !translations.contains(where: { word1 in return word == word1 }) && !originalWords.contains(where: { word1 in return word == word1 }) else { continue }
                        return word
                    }
                }
            }
            return nil
        }
    }
    
    private func addMissingWord(in wordsStatus: WordsStatus, numberExisting: Int, requiredBalance: Int) {
        var requiredBalance = requiredBalance - numberExisting //тут еще нужно передавать 18 в случае малознакомых слов
        var firstSearchGroupWords: WordsStatus = .known
        var secondSearchGroupWords: WordsStatus = .unknown
        
        switch wordsStatus {
        case .known: firstSearchGroupWords = .littleUnknown; secondSearchGroupWords = .unknown
        case .littleUnknown: firstSearchGroupWords = .unknown; secondSearchGroupWords = .known
        case .unknown: firstSearchGroupWords = .littleUnknown; secondSearchGroupWords = .known
        }
        
        while requiredBalance != 0 {
            let word = configureWord(with: firstSearchGroupWords)
            guard let word = word else { break } // здесь
            
            if word.lastShowTranslation {
                originalWords.append(word)
            } else {
                translations.append(word)
            }
            requiredBalance -= 1
        }

        while requiredBalance != 0 {
            let word = configureWord(with: secondSearchGroupWords)
            guard let word = word else { break } // здесь
            
            if word.lastShowTranslation {
                originalWords.append(word)
            } else {
                translations.append(word)
            }
            requiredBalance -= 1
        }
    }
    
    private func checkNumberOfWords(_ savedWords: [Words]) {
        addTrainingWords(from: savedWords)
        
        // проверяем достаточное ли количество известных слов, если нет, то сначала добавляем из малоизвестных, потом из неизвестных
        if knownWords != 6 {
            addMissingWord(in: .known, numberExisting: knownWords, requiredBalance: 6)
        }
        
       // проверяем достаточное ли количество неизвестных слов, если нет, то сначала добавляем из малоизвестных, потом из известных
        if unknownWords != 6 {
            addMissingWord(in: .unknown, numberExisting: unknownWords, requiredBalance: 6)
        }
      // проверяем достаточное ли количество малоизвестных слов, если нет, то сначала добавляем из неизвестных, а потом из известных
        if littleKnownWords != 18 {
            addMissingWord(in: .littleUnknown, numberExisting: unknownWords, requiredBalance: 18)
        }
    }
    
    private func checkBalanceWords() -> Set<String> {
        checkNumberOfWords(savedWords)
        var listTraningWords = Set<String>()
        
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
                listTraningWords.insert(word.translation)
            }
            
            for word in originalWords {
                listTraningWords.insert(word.word)
            }
        
        translations.removeAll()
        originalWords.removeAll()
        unknownWords = 0
        littleKnownWords = 0
        knownWords = 0
        
        return listTraningWords
    }
    
    private func formTrainingWords(from words: [Words]) -> Set<String> {
        return checkBalanceWords()
    }
    
    //метод, чтобы снизить количество угаданных случаев у слова, если человек давно не выполнял тренировку
    private func reduceSuccessRate(of word: Words) -> Bool {
        let addedWords = fetchData(coreDataContext)
        var success = false
        
        for addedWord in addedWords { // в списке ищем нужно слово
            if addedWord.word == word.word {
                do {
                    word.guess -= 2
                    try coreDataContext.save()
                    success = true
                } catch {
                    success = false
                }
                break
            }
        }
        return success
    }
    
    private func consistDateIn(interval minDays: Int, _ maxDays: Int, for word: Words) -> Bool {
        var minDate: Date {
            return Calendar.current.date(byAdding: .day, value: minDays, to: word.date!)!
        }
        var maxDate: Date {
            return Calendar.current.date(byAdding: .day, value: maxDays, to: word.date!)!
        }
        if Date().isBetween(minDate, maxDate) {
            return true
        } else if Date().isLonger(maxDate) {
            let wordGuess = Guess(numberGuess: word.guess)
            if wordGuess.isLittleKnown {
                if reduceSuccessRate(of: word) == false {
                    delegate?.showSavingChangesError()
                }
                return true
            } else {
                return true
            }
        }
        return false
    }
    
    private func check(of word: Words) -> Bool {
        if word.guess <= 3 {
            guard word.date != nil else { return true }
            var wordDate: Date {
                return Calendar.current.date(byAdding: .day, value: 1, to: word.date!)!
            }
            if Date().componentize() == wordDate.componentize() {
                return true
            }
            if Date().isLonger(wordDate) {
                return true
            }
        }
        
        if word.guess > 3 && word.guess <= 8 {
            return consistDateIn(interval: 2, 5, for: word)
        }
        
        if word.guess > 8 && word.guess <= 12 {
            return consistDateIn(interval: 3, 6, for: word)
        }
        
        if word.guess > 12 && word.guess <= 17 {
            return consistDateIn(interval: 7, 10, for: word)
        }
        
        if word.guess > 17 && word.guess <= 21 {
            return consistDateIn(interval: 15, 18, for: word)
        }
        
        if word.guess > 21 && word.guess <= 25 {
            return consistDateIn(interval: 30, 34, for: word)
        }
        return false
    }
}
