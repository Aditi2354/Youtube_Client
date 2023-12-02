//
//  BaseView.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 17.06.2023.
//

import UIKit

class BaseView: UIView {
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        setupSubviews()
        makeSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc
extension BaseView: ViewSetup {
    func configureAppearance() {
        backgroundColor = Resources.Colors.background
    }
    
    func setupSubviews() { }
    
    func makeSubviewsLayout() { }
}
