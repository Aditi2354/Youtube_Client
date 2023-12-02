//
//  HomepageCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import GoogleAPIClientForREST_YouTube

/// A protocol of the "Homepage" module flow coordinator
protocol HomepageCoordinator: VideoPresentingCoordinator {
    var finishFlow: VoidClosure? { get set }
}
