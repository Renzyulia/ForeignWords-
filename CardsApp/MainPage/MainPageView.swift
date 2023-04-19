//
//  MainPageView.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

final class MainPageView: UIView {
    private let newWordButton = Action(title: "New Word")
    private let trainingButton = Action(title: "Training")
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        
        configureNewWordButton()
        configureTrainingButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNewWordButton() {
        addSubview(newWordButton)
        
        newWordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newWordButton.topAnchor.constraint(equalTo: topAnchor, constant: 330),
            newWordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            newWordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60)
        ])
    }
    
    private func configureTrainingButton() {
        addSubview(trainingButton)
        
        trainingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trainingButton.topAnchor.constraint(equalTo: newWordButton.bottomAnchor, constant: 50),
            trainingButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            trainingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60)
        ])
    }
}
