//
//  ViewController.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

class ViewController: UIViewController, ModelDelegate, ViewDelegate {
    var model: Model? = nil
    var menuView: MenuView? = nil
    var newWordView: NewWordView? = nil
    var trainingView: TrainingView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = Model()
        self.model = model
        model.delegate = self
        
        model.viewDidLoad()
    }
    
    func showMainPageView() {
        let menuView = MenuView()
        self.menuView = menuView
        menuView.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.leftAnchor.constraint(equalTo: view.leftAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func didTapNewWordButton() {
        model?.didTapNewWordButton()
    }
    
    func showNewWordView() {
        configureNavigationBar()
        
        let newWordTextFieldDelegate = NewWordTextFieldDelegate()
        let translationTextFieldDelegate = TranslationTextFieldDelegate()
        let contextTextViewDelegate = ContextTextViewDelegate()
        
        let newWordView = NewWordView(
            newWordTextFieldDelegate: newWordTextFieldDelegate,
            translationTextFieldDelegate: translationTextFieldDelegate,
            contextTextViewDelegate: contextTextViewDelegate)
        self.newWordView = newWordView
        newWordView.delegate = self
        
        contextTextViewDelegate.didAttach(to: newWordView.context.textView)
        
        newWordTextFieldDelegate.delegate = model
        translationTextFieldDelegate.delegate = model
        contextTextViewDelegate.delegate = model
        
        view.addSubview(newWordView)
        
        newWordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newWordView.topAnchor.constraint(equalTo: view.topAnchor),
            newWordView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newWordView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newWordView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func didTapSaveButton() {
        model?.didTapSaveButton()
    }
    
    func showSavingError() {
        let alert = UIAlertController(title: nil, message: "Ошибка сохранения данных", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didTapTrainingButton() {
        model?.didTapTrainingButton()
    }
    
    func showTrainingView(for word: String, translation: String, context: String) {
        configureNavigationBar()
        
        let trainingView = TrainingView(wordForTraining: word, translation: translation, context: context)
        self.trainingView = trainingView
        trainingView.delegate = self
        
        view.addSubview(trainingView)
        
        trainingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trainingView.topAnchor.constraint(equalTo: view.topAnchor),
            trainingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            trainingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trainingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func showNoSavedWordsError() {
        let alert = UIAlertController(title: nil, message: "Вы еще не добавили ни одного слова для тренировки", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didTapOnTrainingdView() {
        model?.didTapOnTrainingView()
    }
    
    func showWordDetailsView() {
        trainingView?.showDetails()
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func didTapBackButton() {
        model?.didTapBackButton()
    }
}
