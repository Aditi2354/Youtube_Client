//
//  BaseCollectionViewCell.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
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

//MARK: - ViewSetup

@objc
extension BaseCollectionViewCell: ViewSetup {
    func configureAppearance() { }
    
    func setupSubviews() { }
    
    func makeSubviewsLayout() { }
}
