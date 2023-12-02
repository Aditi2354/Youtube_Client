//
//  YouTubeLogoView.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit
import SnapKit

final class YouTubeLogoView: UIView {
    
    //MARK: - Views
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Resources.Images.youTubeLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setup() {
        addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
}
