//
//  TextFieldDelegate.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 08.05.2023.
//

import UIKit

final class NewWordTextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var delegate: Model?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != " " {
            delegate?.newWord = textField.text
        }
    }
}

final class TranslationTextFieldDelegate: NSObject, UITextFieldDelegate {
    weak var delegate: Model?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != " " {
            delegate?.translation = textField.text
        }
    }
}

final class ContextTextViewDelegate: NSObject, UITextViewDelegate {
    weak var delegate: Model?
    
    private let placeholder = NSAttributedString(
        string: "How the word can be used",
        attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.lightGray
        ])
    
    func didAttach(to textView: UITextView) {
        textView.attributedText = placeholder
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.attributedText = NSAttributedString("")
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 16)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.attributedText = placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        delegate?.context = textView.text
    }
}
