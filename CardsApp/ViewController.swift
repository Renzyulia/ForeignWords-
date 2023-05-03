//
//  ViewController.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

class ViewController: UIViewController, ModelDelegate, ViewDelegate {
    var model: Model? = nil
    var mainPageView: MainPageView? = nil
    var newWordView: NewWordView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = Model()
        self.model = model
        model.delegate = self
        
        model.viewDidLoad()
    }
    
    func showMainPageView() {
        let mainPageView = MainPageView()
        self.mainPageView = mainPageView
        mainPageView.delegate = self
        
        view.addSubview(mainPageView)
        
        mainPageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainPageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainPageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainPageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainPageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func didTapNewWordButton() {
        model?.didTapNewWordButton()
    }
    
    func showNewWordView() {
        let newWordView = NewWordView()
        self.newWordView = newWordView
        
        view.addSubview(newWordView)
        
        newWordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newWordView.topAnchor.constraint(equalTo: view.topAnchor),
            newWordView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newWordView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newWordView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func didTapTrainingButton() {
        model?.didTapTrainingButton()
    }
    
    func showTrainingView() {
        print("tapped")
    }
}

