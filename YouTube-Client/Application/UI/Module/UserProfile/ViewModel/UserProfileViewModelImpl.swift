//
//  UserProfileViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 15.06.2023.
//

import GoogleSignIn

/// View Model implementation for the "User Profile" module
final class UserProfileViewModelImpl: UserProfileViewModel {

    //MARK: Properties
    
    var profileImageURL: URL? {
        user.profile?.imageURL(withDimension: 450)
    }
    
    var username: String {
        user.profile?.name ?? ""
    }
    
    var userEmail: String {
        user.profile?.email ?? ""
    }
    
    private let signInInstance = GIDSignIn.sharedInstance
    private let user: GIDGoogleUser
    private let googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager
    
    private let coordinator: UserProfileCoordinator
    
    //MARK: - Initialization
    
    init(user: GIDGoogleUser,
         googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager,
         coordinator: UserProfileCoordinator) {
        self.user = user
        self.googleOAuthAccessTokenManager = googleOAuthAccessTokenManager
        self.coordinator = coordinator
    }
    
    //MARK: - Methods
    
    func closePage() {
        coordinator.performCoordinate(for: .pageClose)
    }
    
    func signOut() {
        Task {
            signInInstance.signOut()
            try? await googleOAuthAccessTokenManager.deleteAccessToken()
            
            await MainActor.run {
                coordinator.performCoordinate(for: .signOut)
            }
        }
    }
}
