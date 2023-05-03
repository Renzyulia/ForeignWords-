//
//  NewWordView.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

final class NewWordView: UIView {
    private let newWord = TextView(placeholder: "New Word")
    private let translation = TextView(placeholder: "Translation")
    private let context = ContextView()
    private let saveButton = Action(title: "Save")
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        
        configureNewWordTextView()
        configureTranslationTextView()
        configureContextTextView()
        configureSaveButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNewWordTextView() {
       addSubview(newWord)
        
        newWord.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newWord.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            newWord.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -600),
            newWord.leftAnchor.constraint(equalTo: leftAnchor,constant: 42),
            newWord.rightAnchor.constraint(equalTo: rightAnchor, constant: -42)
        ])
    }
    
    private func configureTranslationTextView() {
        addSubview(translation)
        
        translation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            translation.topAnchor.constraint(equalTo: newWord.bottomAnchor, constant: 20),
            translation.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -530),
            translation.leftAnchor.constraint(equalTo: leftAnchor, constant: 42),
            translation.rightAnchor.constraint(equalTo: rightAnchor, constant: -42)
        ])
    }
    
    private func configureContextTextView() {
        addSubview(context)
        
        context.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            context.topAnchor.constraint(equalTo: translation.bottomAnchor, constant: 20),
            context.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -350),
            context.leftAnchor.constraint(equalTo: leftAnchor, constant: 42),
            context.rightAnchor.constraint(equalTo: rightAnchor, constant: -42)
        ])
    }
    
    private func configureSaveButton() {
        addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: context.bottomAnchor, constant: 30),
            saveButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
            saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -70)
        ])
    }
}
