//
//  ActionButton.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

final class Action: UIControl {
    private let title: String
    private let label = UILabel()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureButton()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
    private func configureLabel() {
        label.text = title
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
