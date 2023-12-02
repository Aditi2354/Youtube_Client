//
//  BaseViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

import UIKit

/// The base View Controller, from which other View Controllers
/// are inherited to obtain a single implementation of the
/// style and interfaces for working with child Views
class BaseViewController: UIViewController {
    
    //MARK: - View Controller Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        setupSubviews()
        makeSubviewsLayout()
    }
}

//MARK: - ViewSetup

@objc
extension BaseViewController: ViewSetup {
    func configureAppearance() {
        view.backgroundColor = Resources.Colors.background
    }
    
    func setupSubviews() { }
    
    func makeSubviewsLayout() { }
}
