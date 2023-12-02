//
//  GoogleSignInButton.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

import UIKit

/// Custom button for authorization with Google
///
/// Use this button only in places where you need to log in with a Google account.
final class GoogleSignInButton: UIButton {
    
    //MARK: - Views
    
    private let googleLogoImageView: UIImageView = {
        let imageView = UIImageView(image: Resources.Images.googleLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in with Google"
        label.font = Resources.Fonts.helveticaNeue(size: 18, style: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mainHStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [googleLogoImageView, signInLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    //MARK: - Initialization
    
    init(frame: CGRect = .zero, action: UIAction) {
        super.init(frame: frame)
        addAction(action, for: .touchUpInside)
        configureAppearance()
        setupSubviews()
        makeSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lyfecycle
    
    override func layoutSubviews() {
        layer.cornerRadius = 20
    }
}

//MARK: - ViewSetup

extension GoogleSignInButton: ViewSetup {
    enum UIConstants {
        static let googleLogoSize: CGFloat = 25
        
        static let mainHStackVerticalInset: CGFloat = 15
        static let mainHStackHorizontalInset: CGFloat = 20
    }
    
    func configureAppearance() {
        layer.cornerCurve = .continuous
        backgroundColor = Resources.Colors.secondaryBackground
    }
    
    func setupSubviews() {
        addSubview(mainHStack)
    }
    
    func makeSubviewsLayout() {
        googleLogoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(UIConstants.googleLogoSize)
        }
        
        mainHStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(UIConstants.mainHStackVerticalInset)
            make.leading.trailing.equalToSuperview().inset(UIConstants.mainHStackHorizontalInset)
        }
    }
}
