//
//  ChannelProfileCVCellViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 16.06.2023.
//

import Foundation

final class ChannelProfileCVCellViewModelImpl: ChannelProfileCVCellViewModel {
    
    //MARK: Properties
    
    var channelProfileImageURL: URL? {
        guard let urlString = subscriptionItem.channelProfileImageURL else {
            return nil
        }
        return URL(string: urlString)
    }
    
    var channelTitle: String {
        subscriptionItem.channelTitle ?? ""
    }
    
    private let subscriptionItem: YouTubeSubscription
    
    //MARK: - Initialization
    
    init(subscriptionItem: YouTubeSubscription) {
        self.subscriptionItem = subscriptionItem
    }
}
