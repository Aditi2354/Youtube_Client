//
//  HomepageMenuBar.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 08.05.2023.
//

import UIKit
import SnapKit

final class HomepageMenuBar: UIView {
    
    enum MenuSections: Int, CaseIterable {
        case videoCategories
        case sendFeedbackButton
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<MenuSections, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MenuSections, AnyHashable>
    
    
    //MARK: Properties
    
    private let didSelectVideoCategory: (String) -> Void
    
    private var dataSource: DataSource!
    private var snapshot: Snapshot!
        
    //MARK: - Views
    
    private lazy var menuItemsCollectionView: UICollectionView = {
        let layout = makeCollectionViewCompositionalLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            VideoCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: VideoCategoryCollectionViewCell.identifier
        )
        
        collectionView.register(
            MenuButtonCollectionViewCell.self,
            forCellWithReuseIdentifier: MenuButtonCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    //MARK: - Initialization
    
    init(frame: CGRect = .zero,
         didSelectVideoCategory: @escaping (String) -> Void) {
        self.didSelectVideoCategory = didSelectVideoCategory
        super.init(frame: frame)
        backgroundColor = Resources.Colors.background
        configureCollectionView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configure(videoCategories: [String], menuButtonAction: UIAction) {
        applyDataSourceSnapshot(
            videoCategories: videoCategories,
            menuButtonAction: menuButtonAction
        )
        
        selectFirstAvailableCategory()
    }
}

//MARK: - Private methods

private extension HomepageMenuBar {
    func selectFirstAvailableCategory() {
        guard let firstCategory = getAvailableVideoCategories()?.first else {
            return
        }
        
        menuItemsCollectionView.selectItem(
            at: IndexPath(row: 0, section: MenuSections.videoCategories.rawValue),
            animated: false,
            scrollPosition: .left
        )
        didSelectVideoCategory(firstCategory)
    }
    
    func getAvailableVideoCategories() -> [String]? {
        return snapshot.itemIdentifiers(inSection: .videoCategories) as? [String]
    }
}

//MARK: - CollectionView Configuration

private extension HomepageMenuBar {
    func configureCollectionView() {
        addSubview(menuItemsCollectionView)
        menuItemsCollectionView.delegate = self
        configureCollectionViewDataSource()
    }
    
    func configureCollectionViewDataSource() {
        dataSource = DataSource(collectionView: menuItemsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let menuSection = MenuSections(rawValue: indexPath.section) else {
                fatalError("Invalid index for the section")
            }
            
            switch menuSection {
            case .videoCategories:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VideoCategoryCollectionViewCell.identifier,
                    for: indexPath
                ) as? VideoCategoryCollectionViewCell else {
                    fatalError("The cell for \(indexPath) does not satisfy the requested type \(VideoCategoryCollectionViewCell.identifier)")
                }
                
                if let category = itemIdentifier as? String {
                    cell.configure(with: category)
                }
                
                return cell
            case .sendFeedbackButton:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MenuButtonCollectionViewCell.identifier,
                    for: indexPath
                ) as? MenuButtonCollectionViewCell else {
                    fatalError("The cell for \(indexPath) does not satisfy the requested type \(MenuButtonCollectionViewCell.identifier)")
                }
                
                cell.configure(actionName: "Send feedback")
                
                if let action = itemIdentifier as? UIAction {
                    cell.addButtonAction(action)
                }
                
                return cell
            }
        })
        
        menuItemsCollectionView.dataSource = dataSource
    }
    
    func applyDataSourceSnapshot(videoCategories: [String], menuButtonAction: UIAction) {
        snapshot = Snapshot()
        
        snapshot.appendSections(MenuSections.allCases)
        
        snapshot.appendItems(videoCategories, toSection: .videoCategories)
        snapshot.appendItems([menuButtonAction], toSection: .sendFeedbackButton)
        
        dataSource.apply(snapshot)
    }
    
    func makeCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { [weak self] section, environment in
            guard let self, let menuSection = MenuSections(rawValue: section) else {
                return nil
            }
            
            switch menuSection {
            case .videoCategories:
                return setupVideoCategoriesSection()
            case .sendFeedbackButton:
                return setupMenuButtonSection()
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    //MARK: - Sections setup
    
    func setupVideoCategoriesSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayoutHelper.createItem(
            widthDimension: .estimated(1000),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = CompositionalLayoutHelper.createGroup(
            itemsArrange: .horizontal,
            widthDimension: .estimated(1000),
            heightDimension: .fractionalHeight(1.0),
            subitems: [item]
        )
        
        let section = CompositionalLayoutHelper.createSection(
            group: group,
            interGroupSpacing: 10
        )
        
        return section
    }
    
    func setupMenuButtonSection() -> NSCollectionLayoutSection {
        let item = CompositionalLayoutHelper.createItem(
            widthDimension: .estimated(300),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = CompositionalLayoutHelper.createGroup(
            itemsArrange: .horizontal,
            widthDimension: .estimated(300),
            heightDimention: .fractionalHeight(1.0),
            subitem: item,
            count: 1
        )
        
        let section = CompositionalLayoutHelper.createSection(group: group)
        
        return section
    }
}

//MARK: - UICollectionViewDelegate

extension HomepageMenuBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let availableCategories = getAvailableVideoCategories() else {
            return
        }
        didSelectVideoCategory(availableCategories[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard
            let section = MenuSections(rawValue: indexPath.section),
            let cell = collectionView.cellForItem(at: indexPath)
        else {
            return false
        }
        
        return section != .sendFeedbackButton && !cell.isSelected
    }
}

//MARK: - Layout

private extension HomepageMenuBar {
    enum UIConstants {
        static let collectionViewVerticalPadding: CGFloat = 10
        static let collectionViewHorizontalPadding: CGFloat = 12
    }
    
    func makeConstraints() {
        menuItemsCollectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(UIConstants.collectionViewVerticalPadding)
            make.horizontalEdges.equalToSuperview().inset(UIConstants.collectionViewHorizontalPadding)
        }
    }
}

