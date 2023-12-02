//
//  SubscriptionsMenuBar.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 17.06.2023.
//

import UIKit
import SnapKit

final class SubscriptionsMenuBar: BaseView, ViewModelBindable {

    enum CollectionViewSections {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<CollectionViewSections, YouTubeSubscription>
    typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionViewSections, YouTubeSubscription>
    
    //MARK: Properties
    
    var viewModel: SubscriptionsMenuBarViewModel! {
        didSet {
            applyDataSourceSnapshot(subscriptions: viewModel.subscriptions)
            subscribedChannelsCollectionView.reloadData()
            subscribedChannelsCollectionView.snp.updateConstraints { make in
                make.height.equalTo(subscribedChannelsCollectionView.contentSize.height)
            }
        }
    }
    
    private lazy var dataSource = configureCollectionViewDataSource()
    private var snapshot: Snapshot!
    
    //MARK: - Views
    
    private lazy var subscribedChannelsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewCompositionalLayout()
        )
        collectionView.register(
            SubscribedChannelCollectionViewCell.self,
            forCellWithReuseIdentifier: SubscribedChannelCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let allChannelsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("All", for: .normal)
        button.titleLabel?.font = Resources.Fonts.helveticaNeue(size: 18, style: .medium)
        button.backgroundColor = Resources.Colors.background
        return button
    }()
    
    //MARK: - Methods
    
    func addActionForAllChannelsButton(_ action: UIAction) {
        allChannelsButton.addAction(action, for: .touchUpInside)
    }
        
    //MARK: - Overrided Methods
    
    override func setupSubviews() {
        setupCollectionView()
        addSubview(allChannelsButton)
    }
    
    override func makeSubviewsLayout() {
        allChannelsButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(55)
        }
        
        subscribedChannelsCollectionView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.trailing.equalTo(allChannelsButton.snp.leading)
            make.height.equalTo(50)
        }
    }
}

//MARK: - CollectionView Configuration

private extension SubscriptionsMenuBar {
    func setupCollectionView() {
        addSubview(subscribedChannelsCollectionView)
        subscribedChannelsCollectionView.dataSource = dataSource
        subscribedChannelsCollectionView.delegate = self
    }
    
    func makeCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { sectionIndex, _ in
            let item = CompositionalLayoutHelper.createItem(
                widthDimension: .estimated(100),
                heightDimension: .estimated(100)
            )
            
            let group = CompositionalLayoutHelper.createGroup(
                itemsArrange: .vertical,
                widthDimension: .estimated(100),
                heightDimention: .estimated(100),
                subitem: item,
                count: 1
            )
            
            let section = CompositionalLayoutHelper.createSection(
                group: group,
                interGroupSpacing: 5,
                contentInsets: .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            )
            
            return section
        }
        
        let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfiguration.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: layoutConfiguration)
    }
    
    func configureCollectionViewDataSource() -> DataSource {
        DataSource(collectionView: subscribedChannelsCollectionView) { [weak self] collectionView, indexPath, subscription in
            guard let self else { return UICollectionViewCell() }
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SubscribedChannelCollectionViewCell.identifier,
                for: indexPath
            ) as? SubscribedChannelCollectionViewCell else {
                fatalError("The cell for \(indexPath) does not satisfy the requested type \(VideoCategoryCollectionViewCell.identifier)")
            }
            
            cell.viewModel = viewModel.viewModelForCell(with: subscription)
            
            return cell
        }
    }
    
    func applyDataSourceSnapshot(subscriptions: [YouTubeSubscription]) {
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(subscriptions)
        dataSource.apply(snapshot)
    }
}

//MARK: - UICollectionViewDelegate

extension SubscriptionsMenuBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subscriptions = snapshot.itemIdentifiers(inSection: .main)
        viewModel.channelDidSelect(subscriptions[indexPath.item])
    }
}
