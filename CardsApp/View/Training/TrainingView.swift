//
//  TrainingView.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 09.05.2023.
//

import UIKit

final class TrainingView: UIView {
    weak var delegate: ViewDelegate?
    
    private let wordForTraining: String
    private let translation: String
    private let context: String?
    private let showTranslation: Bool
    private var wordCard: WordCardView?
    private var detailCard: WordDetailsCardView?
    private let knownWordButton = ActionButton(title: "I know")
    private let unknownWordButton = ActionButton(title: "I don't know")
    
    init(wordForTraining: String, translation: String, context: String?, showTranslation: Bool) {
        self.wordForTraining = wordForTraining
        self.translation = translation
        self.context = context
        self.showTranslation = showTranslation
        super.init(frame: .zero)
        
        configureWordCard()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDetails() {
        wordCard?.removeFromSuperview()
        configureWordDetailsCard()
    }
    
    private func configureWordCard() {
        if showTranslation {
            wordCard = WordCardView(wordForTraining: translation)
        } else {
            wordCard = WordCardView(wordForTraining: wordForTraining)
        }
        
        guard let wordCard = wordCard else { return } // выдать здесь ошибку?
        
        addSubview(wordCard)
        
        wordCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wordCard.topAnchor.constraint(equalTo: topAnchor, constant: 130),
            wordCard.leftAnchor.constraint(equalTo: leftAnchor, constant: 42),
            wordCard.rightAnchor.constraint(equalTo: rightAnchor, constant: -42),
            wordCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -180)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnTrainingView))
        tap.cancelsTouchesInView = false
//        wordCard.isUserInteractionEnabled = false
//        self.isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc private func didTapOnTrainingView() {
        delegate?.didTapOnTrainingdView()
    }
    
    private func configureWordDetailsCard() {
        let detailCard = WordDetailsCardView(word: wordForTraining, translation: translation, context: context)
        self.detailCard = detailCard
        
        addSubview(detailCard)
        
        detailCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailCard.topAnchor.constraint(equalTo: topAnchor, constant: 130),
            detailCard.leftAnchor.constraint(equalTo: leftAnchor, constant: 42),
            detailCard.rightAnchor.constraint(equalTo: rightAnchor, constant: -42),
            detailCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -180)
        ])
    }
    
    private func configureButtons() {
        addSubview(knownWordButton)
        addSubview(unknownWordButton)
        
        knownWordButton.addTarget(self, action: #selector(didTapKnownWordButton), for: .touchUpInside)
        unknownWordButton.addTarget(self, action: #selector(didTapUnknownWordButton), for: .touchUpInside)
        
        unknownWordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unknownWordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            unknownWordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 42),
            unknownWordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -210)
        ])
        
        knownWordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            knownWordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            knownWordButton.leftAnchor.constraint(equalTo: unknownWordButton.rightAnchor, constant: 20),
            knownWordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -42),
        ])
    }
    
    @objc private func didTapKnownWordButton() {
        delegate?.didTapKnownWordButton()
    }
    
    @objc private func didTapUnknownWordButton() {
        delegate?.didTapUnknownWordButton()
    }
}
