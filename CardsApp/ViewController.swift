//
//  ViewController.swift
//  CardsApp
//
//  Created by Yulia Ignateva on 19.04.2023.
//

import UIKit

class ViewController: UIViewController {
    var mainPageView: MainPageView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainPageView = MainPageView()
        self.mainPageView = mainPageView
        
        view.addSubview(mainPageView)
        
        mainPageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainPageView.topAnchor.constraint(equalTo: view.topAnchor),
            mainPageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainPageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainPageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

