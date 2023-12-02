//
//  CompositionalLayoutHelper.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 02.05.2023.
//

import UIKit

/// A set of auxiliary methods for creating
/// [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
/// components
///
/// Use this helper for more convenient creation of
/// [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)
/// individual components
///
/// ```swift
/// let item = CompositionalLayoutHelper.createItem(
///     widthDimension: .fractionalWidth(1),
///     heightDimension: .fractionalHeight(1)
/// )
///
/// let group = CompositionalLayoutHelper.createGroup(
///     alignment: .vertical,
///     widthDimension: .fractionalWidth(1),
///     heightDimension: .fractionalHeight(0.3),
///     subitems: [item]
/// )
///
/// let section = CompositionalLayoutHelper.createSection(
///     group: group,
///     interGroupSpacing: 5
/// )
/// ```
enum CompositionalLayoutHelper {
    
    //MARK: GroupItemsArrangement
    
    /// Enumeration of available types of arrangement of [NSCollectionLayoutItem](https://developer.apple.com/documentation/uikit/nscollectionlayoutitem) in [NSCollectionLayoutGroup](https://developer.apple.com/documentation/uikit/nscollectionlayoutgroup)
    enum GroupItemsArrangement {
        case horizontal
        case vertical
    }

    //MARK: - Methods
    
    /// Creates an item, the most basic component of a collection view’s layout.
    /// - Parameters:
    ///   - widthDimension: The width dimension of an item in a collection view layout.
    ///   - heightDimension: The height dimension of an item in a collection view layout.
    ///   - contentInsets: The amount of space added around the content of the item to adjust its final size after its position is computed.
    /// - Returns: An item of the specified dimensions and content insets.
    static func createItem(widthDimension: NSCollectionLayoutDimension,
                           heightDimension: NSCollectionLayoutDimension,
                           contentInsets: NSDirectionalEdgeInsets = .zero) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: widthDimension, heightDimension: heightDimension)
        )
        item.contentInsets = contentInsets
        return item
    }
    

    /// Creates a group containing an array of items arranged in the specified line.
    /// - Parameters:
    ///   - itemsArrange: Type of arrangement of items in the group
    ///   - widthDimension: Width dimension of the group in a collection view layout.
    ///   - heightDimension: Height dimension of the group in a collection view layout.
    ///   - subitems: The array of items located in the group
    ///   - contentInsets: The amount of space added around the content of the item to adjust its final size after its position is computed.
    ///   - interItemSpacing: The amount of space between the items in the group.
    /// - Returns: A group of the specified dimensions, containing an array of items arranged in the specified line.
    static func createGroup(itemsArrange: GroupItemsArrangement,
                            widthDimension: NSCollectionLayoutDimension,
                            heightDimension: NSCollectionLayoutDimension,
                            subitems: [NSCollectionLayoutItem],
                            contentInsets: NSDirectionalEdgeInsets = .zero,
                            interItemSpacing: NSCollectionLayoutSpacing? = nil) -> NSCollectionLayoutGroup {
        var group: NSCollectionLayoutGroup!
        switch itemsArrange {
        case .horizontal:
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: widthDimension,
                    heightDimension: heightDimension
                ),
                subitems: subitems
            )
        case .vertical:
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: widthDimension,
                    heightDimension: heightDimension
                ),
                subitems: subitems
            )
        }
        group.interItemSpacing = interItemSpacing
        group.contentInsets = contentInsets
        return group
    }
    
    
    /// Creates a group of the specified dimentions, containing an array of equally sized items arranged in the specified line up to the number specified by count.
    /// - Parameters:
    ///   - itemsArrange: Type of arrangement of items in the group
    ///   - widthDimension: Width dimension of the group in a collection view layout.
    ///   - heightDimension: Height dimension of the group in a collection view layout.
    ///   - subitem: Type of items located in the group
    ///   - count: Count of items
    ///   - contentInsets: The amount of space added around the content of the item to adjust its final size after its position is computed.
    ///   - interItemSpacing: The amount of space between the items in the group.
    /// - Returns: A group of specified sizes containing an array of elements of the same size up to the specified number
    static func createGroup(itemsArrange: GroupItemsArrangement,
                            widthDimension: NSCollectionLayoutDimension,
                            heightDimention: NSCollectionLayoutDimension,
                            subitem: NSCollectionLayoutItem,
                            count: Int,
                            contentInsets: NSDirectionalEdgeInsets = .zero,
                            interItemSpacing: NSCollectionLayoutSpacing? = nil) -> NSCollectionLayoutGroup {
        let group: NSCollectionLayoutGroup!
                
        switch itemsArrange {
        case .horizontal:
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: widthDimension,
                        heightDimension: heightDimention
                    ),
                    repeatingSubitem: subitem,
                    count: count
                )
            } else {
                group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: widthDimension,
                        heightDimension: heightDimention
                    ),
                    subitem: subitem,
                    count: count
                )
            }
        case .vertical:
            if #available(iOS 16.0, *) {
                group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: widthDimension,
                        heightDimension: heightDimention
                    ),
                    repeatingSubitem: subitem,
                    count: count
                )
            } else {
                group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: widthDimension,
                        heightDimension: heightDimention
                    ),
                    subitem: subitem,
                    count: count
                )
            }
        }
        
        group.interItemSpacing = interItemSpacing
        group.contentInsets = contentInsets
        
        return group
    }
    
    /// Creates a section that combines a set of groups into distinct visual groupings.
    /// - Parameters:
    ///   - group: Instance of group in the section
    ///   - scrollingBehavior: The section’s scrolling behavior in relation to the main layout axis.
    ///   - interGroupSpacing: The amount of space between the groups in the section.
    ///   - contentInsets: The amount of space between the content of the section and its boundaries.
    /// - Returns: A container that combines a set of groups into distinct visual groupings.
    static func createSection(group: NSCollectionLayoutGroup,
                              scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
                              interGroupSpacing: CGFloat = 0,
                              contentInsets: NSDirectionalEdgeInsets = .zero) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehavior
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = contentInsets
        return section
    }
}
