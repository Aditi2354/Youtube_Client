//
//  SubscriptionsMenuBarViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 17.06.2023.
//

final class SubscriptionsMenuBarViewModelImpl: SubscriptionsMenuBarViewModel {
    
    //MARK: Properties
    
    var subscriptions = [YouTubeSubscription]()
    var channelDidSelect: (YouTubeSubscription) -> Void
        
    //MARK: - Initialization
    
    init(subscriptions: [YouTubeSubscription],
         channelDidSelect: @escaping (YouTubeSubscription) -> Void) {
        self.subscriptions = subscriptions
        self.channelDidSelect = channelDidSelect
    }
    
    //MARK: - Methods

    func viewModelForCell(with subscription: YouTubeSubscription) -> ChannelProfileCVCellViewModel {
        ChannelProfileCVCellViewModelImpl(subscriptionItem: subscription)
    }
}
