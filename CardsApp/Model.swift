//
//  NewWordModel.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 03.05.2023.
//

import UIKit

final class Model {
    weak var delegate: ModelDelegate?
    
    func viewDidLoad() {
        delegate?.showMainPageView()
    }
    
    func didTapNewWordButton() {
        delegate?.showNewWordView()
    }
    
    func didTapTrainingButton() {
        delegate?.showTrainingView()
    }
}
