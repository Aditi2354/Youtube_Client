//
//  ShortsViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// View Model implementation for the "Shorts" module
final class ShortsViewModelImpl: ShortsViewModel {

    //MARK: Properties
    
    private let coordinator: ShortsCoordinator
    
    //MARK: - Initialization
    
    init(coordinator: ShortsCoordinator) {
        self.coordinator = coordinator
    }
    
}
