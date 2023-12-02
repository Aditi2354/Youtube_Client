//
//  BaseNavigationController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    
    //MARK: - View Controller Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

//MARK: - Private methods

private extension BaseNavigationController {
    func setupNavigationBar() {
        navigationBar.tintColor = .label
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = Resources.Colors.background
        view.backgroundColor = Resources.Colors.background
    }
}
