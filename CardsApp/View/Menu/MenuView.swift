//
//  MainPageView.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

final class MenuView: UIView {
    weak var delegate: ViewDelegate?
    
    private let newWordButton = ActionButton(title: "New Word")
    private let trainingButton = ActionButton(title: "Training")
    
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
        newWordButton.addTarget(self, action: #selector(didTapNewWordButton), for: .touchUpInside)
        
        addSubview(newWordButton)
        
        newWordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newWordButton.topAnchor.constraint(equalTo: topAnchor, constant: 330),
            newWordButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            newWordButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60)
        ])
    }
    
    @objc private func didTapNewWordButton() {
        delegate?.didTapNewWordButton()
    }
    
    private func configureTrainingButton() {
        trainingButton.addTarget(self, action: #selector(didTapTrainingButton), for: .touchUpInside)
        
        addSubview(trainingButton)
        
        trainingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trainingButton.topAnchor.constraint(equalTo: newWordButton.bottomAnchor, constant: 50),
            trainingButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            trainingButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -60)
        ])
    }
    
    @objc private func didTapTrainingButton() {
        delegate?.didTapTrainingButton()
    }
}
