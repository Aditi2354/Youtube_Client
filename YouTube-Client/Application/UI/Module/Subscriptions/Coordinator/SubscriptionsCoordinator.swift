//
//  SubscriptionsCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// A protocol of the "Subscriptions" module flow coordinator
protocol SubscriptionsCoordinator: VideoPresentingCoordinator {
    var finishFlow: VoidClosure? { get set }
}
