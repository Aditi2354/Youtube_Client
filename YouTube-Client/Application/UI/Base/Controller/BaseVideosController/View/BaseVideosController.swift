//
//  BaseVideosController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit
import Combine

/// Basic View Controller for controllers with YouTube video collections
///
/// The basic View Controller, from which the controllers for the
/// "Homepage", "Subscriptions" and "User Video Library" modules are inherited
class BaseVideosController: BaseViewController {
    
    enum CollectionViewSection: Int {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<CollectionViewSection, YouTubeVideoPreview>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, YouTubeVideoPreview>
    
    //MARK: Properties
    
    private var lastContentOffset: CGFloat = 0
    private var hideNavBarThreshold: CGFloat = 100
    
    private var viewModel: BaseVideosControllerViewModel = BaseVideosControllerViewModelImpl()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var userProfileBarButtonItem: UIBarButtonItem = {
        let profileImageView = ProfileImageView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: 25, height: 25)
            )
        )
        
        profileImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(userProfileItemTapped))
        )
        
        return UIBarButtonItem(customView: profileImageView)
    }()
    
    private lazy var searchBarButtonItem: UIBarButtonItem = UIBarButtonItem(
        image: Resources.Images.magnifyingglass,
        style: .plain,
        target: self,
        action: #selector(searchItemTapped)
    )
    
    private lazy var notificationsBarButtonItem: UIBarButtonItem = UIBarButtonItem(
        image: Resources.Images.bell,
        style: .plain,
        target: self,
        action: #selector(notificationsItemTapped)
    )
    
    //MARK: - View Controller Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBindings()
    }
    
    //MARK: - Overrided Methods
    
    override func configureAppearance() {
        super.configureAppearance()
        setupNavigationBarItems()
    }
}

//MARK: - Actions

@objc
private extension BaseVideosController {
    func searchItemTapped() {
        viewModel.showSearchPage()
    }
    
    func notificationsItemTapped() {
        print(#function)
    }
    
    func userProfileItemTapped(_ gesture: UITapGestureRecognizer) {
        viewModel.showUserProfilePage()
    }
}

//MARK: - Private methods

private extension BaseVideosController {
    func makeBindings() {
        viewModel.userSessionRestorePublisher
            .sink { [weak self] in
                self?.loadProfileImage()
            }
            .store(in: &cancellables)
    }
    
    func loadProfileImage() {
        guard let imageView = userProfileBarButtonItem.customView as? UIImageView else {
            return
        }
        
        guard let profileImageURL = viewModel.userProfileImageURL else {
            imageView.image = nil
            return
        }
        
        Task {
            do {
                try await imageView.loadImage(from: profileImageURL)
            } catch {
                await MainActor.run {
                    imageView.image = nil
                }
            }
        }
    }
    
    func setupNavigationBarItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: YouTubeLogoView())
        
        navigationItem.rightBarButtonItems = [
            userProfileBarButtonItem,
            searchBarButtonItem,
            notificationsBarButtonItem
        ]
    }
}

//MARK: - Navigation Bar Hide

extension BaseVideosController {
    func changeNavigationBarVisibility(scrollOffsetByY: CGFloat) {
        let scrollDelta = scrollOffsetByY - lastContentOffset
        
        guard abs(scrollDelta) > hideNavBarThreshold else { return }
        
        if scrollDelta > 0, scrollOffsetByY > 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        lastContentOffset = scrollOffsetByY
    }
}

//MARK: - UIScrollViewDelegate

extension BaseVideosController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeNavigationBarVisibility(scrollOffsetByY: scrollView.contentOffset.y)
        scrollView.bounces = scrollView.contentOffset.y < scrollView.contentSize.height / 2
    }
}
