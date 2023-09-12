//
//  ViewController.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit
import Swinject

final class NewWordViewController: BaseViewController, NewWordModelDelegate, NewWordViewDelegate {
    weak var delegate: NewWordAndTrainingViewControllersDelegate?
    var newWordModel: NewWordModel? = nil
    var newWordView: NewWordView? = nil
    private let container: Resolver
    
    init(container: Resolver) {
        self.container = container
        super.init(navigationBarVisibility: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestureToHideKeyboard()
      
      
      // MARK: For practice to injecting DI by Swinject
      let someString = "SomeString"
      let titleScreen = "Screen"
        
      let newWordModel = NewWordModel(storage: container.resolve(Storage.self)!,
                                      logger: container.resolve(LoggerProtocol.self, arguments: someString, titleScreen)!)
        self.newWordModel = newWordModel
        newWordModel.delegate = self
        
        newWordModel.viewDidLoad()
    }
    
    override func handleDidTapBackButton() {
        newWordModel?.didTapBackButton()
    }
    
    func showNewWordView() {
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
        
        newWordTextFieldDelegate.delegate = newWordModel
        translationTextFieldDelegate.delegate = newWordModel
        contextTextViewDelegate.delegate = newWordModel
        
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
        newWordModel?.didTapSaveButton()
    }
    
    func showSavingError() {
        let alert = UIAlertController(title: nil, message: "Ошибка сохранения данных", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showRepeatWordError() {
        let alert = UIAlertController(title: nil, message: "Вы уже добавляли такое слово", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] UIAlertAction in
            self?.showNewWordView()
        })
        present(alert, animated: true)
    }
    
    func notifyCompletion() {
        delegate?.onFinish()
    }
}
