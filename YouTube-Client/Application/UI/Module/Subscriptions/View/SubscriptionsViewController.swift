//
//  SubscriptionsViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit
import SnapKit
import Combine

/// The View Controller of the "Subscriptions" module
final class SubscriptionsViewController: BaseVideosController, VideoPresentingViewController {

    //MARK: Properties
    
    var viewModel: SubscriptionsViewModel! {
        didSet {
            makeBindings()
            viewModel.fetchSubscriptionsSubject.send()
        }
    }
    
    private lazy var dataSource = createCollectionViewDataSource()
    private var snapshot: Snapshot!
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var loadingIndicator = LoadingIndicator()
    
    private lazy var subscriptionsMenuBar: SubscriptionsMenuBar = {
        let menuBar = SubscriptionsMenuBar()
        menuBar.addActionForAllChannelsButton(UIAction { [weak self] in
            self?.showAllSubscriptions($0)
        })
        return menuBar
    }()
    
    private lazy var subscriptionVideosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.baseYouTubeVideosListLayout
        )
        collectionView.register(
            VideoPreviewCollectionViewCell.self,
            forCellWithReuseIdentifier: VideoPreviewCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: - Overrided Methods
    
    override func setupSubviews() {
        view.addSubview(loadingIndicator)
        view.addSubview(subscriptionsMenuBar)
        setupCollectionView()
    }
    
    override func makeSubviewsLayout() {
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview(\.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subscriptionsMenuBar.snp.makeConstraints { make in
            make.top.equalToSuperview(\.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide.snp.horizontalEdges)
            make.height.greaterThanOrEqualTo(view.frame.height * 0.1)
        }
        
        subscriptionVideosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subscriptionsMenuBar.snp.bottom)
            make.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide.snp.horizontalEdges)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Actions

private extension SubscriptionsViewController {
    func showAllSubscriptions(_ action: UIAction) {
        guard action.sender is UIButton else { return }
        print(#function)
    }
}

//MARK: - Private methods

private extension SubscriptionsViewController {
    func makeBindings() {
        viewModel.dataLoadPublisher
            .sink { [weak self] in self?.updateUI(isLoading: $0) }
            .store(in: &cancellables)
        
        viewModel.subscriptionsVideosPublisher
            .sink { [weak self] in self?.applyDataSourceSnapshot(with: $0) }
            .store(in: &cancellables)
        
        viewModel.subscriptionsChangePublisher
            .sink { [weak self] in
                self?.subscriptionsMenuBar.viewModel = self?.viewModel.viewModelForSubscriptionsMenuBar()
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showAlert(title: "Error occured", message: error.localizedDescription, actions: [
                    UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
                        self?.viewModel.fetchSubscriptionsSubject.send()
                    }
                ])
            }
            .store(in: &cancellables)
    }
    
    func updateUI(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        subscriptionsMenuBar.isHidden = isLoading
        subscriptionVideosCollectionView.isHidden = isLoading
    }
}

//MARK: - Collection View Configuartion

private extension SubscriptionsViewController {
    func setupCollectionView() {
        view.addSubview(subscriptionVideosCollectionView)
        subscriptionVideosCollectionView.dataSource = dataSource
        subscriptionVideosCollectionView.delegate = self
    }
    
    func createCollectionViewDataSource() -> DataSource {
        DataSource(collectionView: subscriptionVideosCollectionView) { [weak viewModel] collectionView, indexPath, videoPreview in
            guard let viewModel else { return UICollectionViewCell() }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPreviewCollectionViewCell.identifier, for: indexPath) as? VideoPreviewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.viewModel = viewModel.viewModelForCell(with: videoPreview)
            return cell
        }
    }
    
    func applyDataSourceSnapshot(with videos: [YouTubeVideoPreview]) {
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        
        dataSource.apply(snapshot)
    }
}

//MARK: - UICollectionViewDelegate

extension SubscriptionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentVideo(for: indexPath, from: collectionView)
    }
}
