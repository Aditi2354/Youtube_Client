//
//  HomepageViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit
import Combine

/// The View Controller of the "Homepage" module
final class HomepageViewController: BaseVideosController, VideoPresentingViewController {

    //MARK: - Typealiases
    
    typealias ViewModel = HomepageViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            makeBindings()
        }
    }
    
    private lazy var dataSource = createCollectionViewDataSource()
    private var snapshot: Snapshot!
    
    private var getRecomendationsTask: Task<Void, Never>?
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var loadingIndicator = LoadingIndicator()
    
    private lazy var topMenuBar: HomepageMenuBar = {
        let menuBar = HomepageMenuBar(
            didSelectVideoCategory: { [weak self] in
                self?.changeCategory(to: $0)
            }
        )
        
        menuBar.configure(
            videoCategories: viewModel.recomendedVideosCategories,
            menuButtonAction: UIAction { [weak self] in
                self?.sendFeedback($0)
            }
        )
        
        return menuBar
    }()
    
    private lazy var videoRecomendationsCollectionView: UICollectionView = {
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
    
    //MARK: - Overrided Methods
    
    override func setupSubviews() {
        view.addSubview(topMenuBar)
        view.addSubview(loadingIndicator)
        setupCollectionView()
    }
    
    override func makeSubviewsLayout() {
        topMenuBar.snp.makeConstraints { make in
            make.top.equalToSuperview(\.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(topMenuBar.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        videoRecomendationsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topMenuBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

//MARK: - Actions

private extension HomepageViewController {
    func sendFeedback(_ action: UIAction) {
        guard action.sender is UIButton else { return }
        print(#function)
    }
}

//MARK: - Private methods

private extension HomepageViewController {
    func changeCategory(to category: String) {
        viewModel.videosCategorySubject.send(category)
    }
    
    func makeBindings() {
        viewModel.videosListPublisher
            .sink { [weak self] videos in
                self?.applySnapshot(with: videos)
            }
            .store(in: &cancellables)
        
        viewModel.dataLoadingPublisher
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showAlert(title: "Error occured", message: error.localizedDescription, actions: [
                    UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
                        self?.viewModel.retryLoadRecomendationsSubject.send()
                    }
                ])
            }
            .store(in: &cancellables)
    }
}

//MARK: - CollectionView configuration

private extension HomepageViewController {
    func setupCollectionView() {
        view.addSubview(videoRecomendationsCollectionView)
        videoRecomendationsCollectionView.dataSource = dataSource
        videoRecomendationsCollectionView.delegate = self
    }

    func createCollectionViewDataSource() -> DataSource {
        return DataSource(collectionView: videoRecomendationsCollectionView, cellProvider: { [weak self] collectionView, indexPath, videoPreview in
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

extension HomepageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentVideo(for: indexPath, from: collectionView)
    }
}
