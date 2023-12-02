//
//  SubscriptionsViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import Combine

/// A protocol that provides an interface for working with the View Model of the "Subscriptions" View Controller
protocol SubscriptionsViewModel: AnyObject, VideoPresentingViewModel {
    var dataLoadPublisher: AnyPublisher<Bool, Never> { get }
    
    var subscriptionsVideosPublisher: AnyPublisher<[YouTubeVideoPreview], Never> { get }
    
    var subscriptionsChangePublisher: AnyPublisher<Void, Never> { get }
    
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    var fetchSubscriptionsSubject: PassthroughSubject<Void, Never> { get }
    
    func viewModelForSubscriptionsMenuBar() -> SubscriptionsMenuBarViewModel
    
    func viewModelForCell(with videoPreview: YouTubeVideoPreview) -> VideoPreviewCellViewModel
    
}
