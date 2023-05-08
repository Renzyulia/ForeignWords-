//
//  TextViewDelegate.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 07.05.2023.
//

import UIKit

final class TextViewDelegate: NSObject, UITextViewDelegate {
    // model - delegate
    
    private let placeholder = NSAttributedString(
        string: "How the word can be used",
        attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ])
    
    func didAttach(to textView: UITextView) {
        textView.attributedText = placeholder
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.attributedText = NSAttributedString(" ")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.attributedText == NSAttributedString(" ") {
            textView.attributedText = placeholder
        }
    }
}
