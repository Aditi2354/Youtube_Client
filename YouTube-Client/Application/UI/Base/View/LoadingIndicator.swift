//
//  LoadingIndicator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 23.06.2023.
//

import UIKit

final class LoadingIndicator: UIActivityIndicatorView {
    
    //MARK: - Initialization
    
    init(frame: CGRect = .zero, style: Style = .medium) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private methods

private extension LoadingIndicator {
    func configure() {
        hidesWhenStopped = true
        style = .medium
    }
}
