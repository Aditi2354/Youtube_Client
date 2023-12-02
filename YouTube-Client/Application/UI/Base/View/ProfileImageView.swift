//
//  ProfileImageView.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit

final class ProfileImageView: CircleImageView {
    
    //MARK: - Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private methods

private extension ProfileImageView {
    func setup() {
        backgroundColor = Resources.Colors.secondaryBackground
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
