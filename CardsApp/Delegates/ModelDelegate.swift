//
//  ModelDelegate.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 03.05.2023.
//

import UIKit

protocol ModelDelegate: AnyObject {
    func showMainPageView()
    func showNewWordView()
    func showTrainingView()
    func showSavingError()
}
