//
//  UICollectionViewCompositionalLayout + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 23.06.2023.
//

import UIKit.UICollectionViewCompositionalLayout

extension UICollectionViewCompositionalLayout {
    static var baseYouTubeVideosListLayout: UICollectionViewCompositionalLayout {
        let item = CompositionalLayoutHelper.createItem(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1000)
        )
        
        let group = CompositionalLayoutHelper.createGroup(
            itemsArrange: .vertical,
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1000),
            subitems: [item]
        )
        
        let section = CompositionalLayoutHelper.createSection(
            group: group,
            interGroupSpacing: 20
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
