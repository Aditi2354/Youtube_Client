//
//  VideoPresentingViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 04.07.2023.
//

import UIKit

protocol VideoPresentingViewController: UIViewController, ViewModelBindable { }

extension VideoPresentingViewController {
    func presentVideo(for indexPath: IndexPath, from collectionView: UICollectionView) {
        guard
            let videoPresenterViewModel = viewModel as? VideoPresentingViewModel,
            let cell = collectionView.cellForItem(at: indexPath) as? VideoPreviewCollectionViewCell,
            let channel = (cell.viewModel as? VideoPreviewCellViewModelImpl)?.channel
        else {
            return
        }
        
        videoPresenterViewModel.presentVideo(forIndexPath: indexPath, channel: channel)
    }
}
