//
//  MainViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import Foundation
import Combine
import GoogleSignIn

/// View Model implementation for the "Main" module
final class MainViewModelImpl: MainViewModel {
    
    //MARK: Properties
    
    private let googleAuthService: GoogleAuthService
    private let coordinator: MainCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initialization
    
    init(googleAuthService: GoogleAuthService,
         coordinator: MainCoordinator) {
        self.googleAuthService = googleAuthService
        self.coordinator = coordinator
        makeBindings()
    }
    
    //MARK: - Methods
    
    func restoreUserSession() async throws {
        let user = try await googleAuthService.restoreUserSession()
        NotificationCenter.default.post(name: .GoogleUserSessionRestore, object: user)
    }
}

//MARK: - Private methods

private extension MainViewModelImpl {
    func makeBindings() {
        NotificationCenter
            .default
            .publisher(for: .YTClientOpenUserProfilePage)
            .sink { [weak self] notification in
                guard let user = notification.object as? GIDGoogleUser else { return }
                self?.coordinator.showUserProfilePage(for: user)
            }
            .store(in: &cancellables)
        
        NotificationCenter
            .default
            .publisher(for: .YTClientOpenSearchPage)
            .sink { [weak coordinator] _ in
                coordinator?.runSearchFlow()
            }
            .store(in: &cancellables)
    }
}
