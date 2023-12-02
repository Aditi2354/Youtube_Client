//
//  UserProfileViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import UIKit
import SnapKit

/// The View Controller of the "User Profile" module
final class UserProfileViewController: BaseViewController, ViewModelBindable {
    
    //MARK: Properties
    
    var viewModel: UserProfileViewModel!
    
    //MARK: - Views
    
    private lazy var closePageButton = UIBarButtonItem(
        image: Resources.Images.close?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)),
        primaryAction: UIAction { [weak self] in
            self?.closePage($0)
        }
    )
    
    private lazy var userProfileImageView = ProfileImageView(frame: .zero)
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.username
        label.font = Resources.Fonts.helveticaNeue(size: 18, style: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.userEmail
        label.font = Resources.Fonts.helveticaNeue(size: 15, style: .regular)
        label.textColor = Resources.Colors.secondaryText
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var userInfoHSTack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            userProfileImageView,
            userInfoLabelsVStack
        ])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .top
        return stack
    }()
    
    private lazy var userInfoLabelsVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            usernameLabel,
            userEmailLabel,
            signOutButton
        ])
        stack.setCustomSpacing(20, after: userEmailLabel)
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.tintColor = .systemRed
        button.titleLabel?.font = Resources.Fonts.helveticaNeue(size: 17, style: .medium)
        button.addAction(
            UIAction { [weak self] in
                self?.signOut($0)
            },
            for: .touchUpInside
        )
        return button
    }()
    
    //MARK: - Overrided Methods
    
    override func configureAppearance() {
        super.configureAppearance()
        setupNavigationBar()
    }
    
    override func setupSubviews() {
        view.addSubview(userInfoHSTack)
        loadUserProfileImage()
    }
    
    override func makeSubviewsLayout() {
        makeConstraints()
    }
}

//MARK: - Actions

private extension UserProfileViewController {
    func closePage(_ action: UIAction) {
        guard action.sender is UIBarButtonItem else { return }
        viewModel.closePage()
    }
    
    func signOut(_ action: UIAction) {
        guard action.sender is UIButton else { return }
        viewModel.signOut()
    }
}

//MARK: - Private methods

private extension UserProfileViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.leftBarButtonItem = closePageButton
    }
    
    func loadUserProfileImage() {
        guard let profileImageURL = viewModel.profileImageURL else { return }
        
        Task {
            try? await userProfileImageView.loadImage(from: profileImageURL)
        }
    }
}

//MARK: - Layout

private extension UserProfileViewController {
    func makeConstraints() {
        makeUserProfileImageConstraints()
        makeUserInfoHStackConstraints()
    }
    
    func makeUserProfileImageConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }
    }
    
    func makeUserInfoHStackConstraints() {
        userInfoHSTack.snp.makeConstraints { make in
            make.top.equalToSuperview(\.safeAreaLayoutGuide.snp.top).offset(20)
            make.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide.snp.horizontalEdges).inset(16)
        }
    }
}
