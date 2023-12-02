//
//  UserLibraryViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// View Model implementation for the "User Library" module
final class UserLibraryViewModelImpl: UserLibraryViewModel {

    //MARK: Properties
    
    private let coordinator: UserLibraryCoordinator
    
    //MARK: - Initialization
    
    init(coordinator: UserLibraryCoordinator) {
        self.coordinator = coordinator
    }
}
