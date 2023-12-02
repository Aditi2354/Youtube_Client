//
//  ShortsCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// A protocol of the "Shorts" module flow coordinator
protocol ShortsCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
}
