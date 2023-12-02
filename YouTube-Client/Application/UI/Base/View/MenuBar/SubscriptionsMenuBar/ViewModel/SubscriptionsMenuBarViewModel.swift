//
//  SubscriptionsMenuBarViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 17.06.2023.
//

protocol SubscriptionsMenuBarViewModel: AnyObject {
    var subscriptions: [YouTubeSubscription] { get }
    var channelDidSelect: (YouTubeSubscription) -> Void { get }
    func viewModelForCell(with subscription: YouTubeSubscription) -> ChannelProfileCVCellViewModel
}
