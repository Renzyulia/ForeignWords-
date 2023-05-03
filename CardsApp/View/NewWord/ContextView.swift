//
//  ContextView.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

final class ContextView: UIView {
    private let textView = UITextView()
    
    init() {
        super.init(frame: .zero)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextView() {
        textView.placeholder  = "How the word can be used"
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .black
        textView.textAlignment = .left
        textView.layer.cornerRadius = 14.5
        textView.layer.masksToBounds = true
        
        addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
