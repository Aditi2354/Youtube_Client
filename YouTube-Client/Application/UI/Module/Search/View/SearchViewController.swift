//
//  SearchViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 01.07.2023.
//

import UIKit
import SnapKit
import Combine

final class SearchViewController: BaseViewController, VideoPresentingViewController {
    
    enum CollectionViewSection: Int {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<CollectionViewSection, YouTubeVideoPreview>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, YouTubeVideoPreview>
    
    //MARK: Properties
    
    var viewModel: SearchViewModel! {
        didSet {
            makeBindings()
        }
    }
    
    private lazy var dataSource = createCollectionViewDataSource()
    private var snapshot: Snapshot!
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var loadingIndicator = LoadingIndicator(style: .large)
    
    private lazy var searchBar: YTSearchBar = {
        let bar = YTSearchBar()
        bar.searchTextField.returnKeyType = .search
        bar.keyboardSearchTapCallback = { [weak self] in
            self?.keyboardSearchButtonTapped()
        }
        return bar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        button.addAction(
            UIAction(handler: { [weak self] in
                self?.goBack($0)
            }),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var topHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            backButton,
            searchBar
        ])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.baseYouTubeVideosListLayout
        )
        collectionView.backgroundColor = .clear
        collectionView.register(
            VideoPreviewCollectionViewCell.self,
            forCellWithReuseIdentifier: VideoPreviewCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    //MARK: - View Controller Lyfecycle
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.perfomCoordinate(for: .viewDidDissappear)
    }
    
    //MARK: - Overrided Methods
    
    override func configureAppearance() {
        super.configureAppearance()
        addKeyboardDoneButton()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    override func setupSubviews() {
        view.addSubview(loadingIndicator)
        view.addSubview(topHStack)
        setupCollectionView()
    }
    
    override func makeSubviewsLayout() {
        topHStack.snp.makeConstraints { make in
            make.top.equalToSuperview(\.safeAreaLayoutGuide.snp.top).offset(10)
            make.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide.snp.horizontalEdges).inset(10)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(topHStack.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topHStack.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide.snp.horizontalEdges)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Actions

private extension SearchViewController {
    func goBack(_ action: UIAction) {
        guard action.sender is UIButton else { return }
        viewModel.perfomCoordinate(for: .backButtonTapped)
    }
    
    func keyboardDoneButtonAction(_ action: UIAction) {
        guard action.sender is UIBarButtonItem else { return }
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func keyboardSearchButtonTapped() {
        searchVideos()
        searchBar.searchTextField.resignFirstResponder()
    }
}

//MARK: - Private methods

private extension SearchViewController {
    func searchVideos() {
        guard let searchQuery = searchBar.searchTextField.text else { return }
        loadingIndicator.startAnimating()
        
        Task {
            do {
                try await viewModel.search(searchQuery: searchQuery)
            } catch {
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    showAlert(title: "Error occured", message: error.localizedDescription, actions: [
                        UIAlertAction(title: "OK", style: .cancel),
                        UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] _ in
                            self?.searchVideos()
                        })
                    ])
                }
            }
        }
    }
    
    func addKeyboardDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            systemItem: .done,
            primaryAction: UIAction { [weak self] in
                self?.keyboardDoneButtonAction($0)
            }
        )
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            doneButton
        ]
        
        searchBar.searchTextField.inputAccessoryView = toolbar
    }
    

    func makeBindings() {
        viewModel.searchResultsPublisher
            .sink { [weak self] videos in
                self?.loadingIndicator.stopAnimating()
                self?.applySnapshot(with: videos)
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - CollectionView configuration

private extension SearchViewController {
    func setupCollectionView() {
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.dataSource = dataSource
        searchResultsCollectionView.delegate = self
    }

    func createCollectionViewDataSource() -> DataSource {
        return DataSource(collectionView: searchResultsCollectionView, cellProvider: { [weak self] collectionView, indexPath, videoPreview in
            guard let self else { return UICollectionViewCell() }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPreviewCollectionViewCell.identifier, for: indexPath) as? VideoPreviewCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.viewModelForCell(with: videoPreview)
            return cell
        })
    }
    
    func applySnapshot(with videos: [YouTubeVideoPreview]) {
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        
        dataSource.apply(snapshot)
    }
}

//MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentVideo(for: indexPath, from: collectionView)
    }
}

//MARK: - UIGestureRecognizerDelegate

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
