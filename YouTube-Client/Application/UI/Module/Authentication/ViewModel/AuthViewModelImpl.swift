//
//  AuthViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

final class AuthViewModelImpl: AuthViewModel {

    //MARK: Properties
    
    private let coordinator: AuthCoordinator
    private let googleAuthService: GoogleAuthService
    
    //MARK: - Initialization
    
    init(coordinator: AuthCoordinator, googleAuthService: GoogleAuthService) {
        self.coordinator = coordinator
        self.googleAuthService = googleAuthService
    }

    @MainActor
    func signInWithGoogle(presentFrom presenter: Presentable) async throws {
        try await googleAuthService.signIn(presenting: presenter)
        coordinator.performCoordinate(for: .signIn)
    }
}
