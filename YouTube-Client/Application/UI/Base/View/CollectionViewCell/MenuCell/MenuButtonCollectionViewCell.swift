//
//  MenuButtonCollectionViewCell.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 08.05.2023.
//

import UIKit
import SnapKit

final class MenuButtonCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Views
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Resources.Fonts.helveticaNeue(size: 17, style: .medium)
        return button
    }()
    
    //MARK: - Methods
    
    func configure(actionName: String) {
        actionButton.setTitle(actionName, for: .normal)
    }
    
    func addButtonAction(_ action: UIAction) {
        actionButton.addAction(action, for: .touchUpInside)
    }
    
    //MARK: - Overrided Methods
    
    override func setupSubviews() {
        contentView.addSubview(actionButton)
        
    }
    
    override func makeSubviewsLayout() {
        makeConstraints()
    }
}

//MARK: - Layout

private extension MenuButtonCollectionViewCell {
    enum UIConstants {
        static let buttonHorizontalPadding: CGFloat = 12
        static let buttonVerticalPadding: CGFloat = 10
    }
    
    func makeConstraints() {
        actionButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(UIConstants.buttonVerticalPadding)
            make.horizontalEdges.equalToSuperview().inset(UIConstants.buttonHorizontalPadding)
        }
    }
}
