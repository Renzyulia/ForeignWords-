//
//  TrainingViewDelegate.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 28.05.2023.
//

import UIKit

protocol TrainingViewDelegate: AnyObject {
    func didTapOnTrainingdView()
    func didTapKnownWordButton()
    func didTapUnknownWordButton()
}
