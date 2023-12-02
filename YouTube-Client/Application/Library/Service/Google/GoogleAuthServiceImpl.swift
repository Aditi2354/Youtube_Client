//
//  GoogleAuthServiceImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import GoogleSignIn
import GoogleAPIClientForREST_YouTube

struct GoogleAuthServiceImpl: GoogleAuthService {
    
    //MARK: Properties
    
    var currentUser: GIDGoogleUser? {
        signInInstance.currentUser
    }
    
    private let signInInstance = GIDSignIn.sharedInstance
    private let authAccessTokenManager: GoogleOAuthAccessTokenManager
    
    //MARK: - Initialization
    
    init(authAccessTokenManager: GoogleOAuthAccessTokenManager) {
        self.authAccessTokenManager = authAccessTokenManager
    }
    
    //MARK: - Methods
    
    @MainActor
    func signIn(presenting: Presentable) async throws {
        guard let presentingViewController = presenting.toPresent else { return }
        
        let scopes = [
            kGTLRAuthScopeYouTube,
            kGTLRAuthScopeYouTubeChannelMembershipsCreator,
            kGTLRAuthScopeYouTubeForceSsl,
            kGTLRAuthScopeYouTubeReadonly,
            kGTLRAuthScopeYouTubeUpload,
            kGTLRAuthScopeYouTubeYoutubepartner,
            kGTLRAuthScopeYouTubeYoutubepartnerChannelAudit
        ]
        
        let signInResult = try await signInInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil,
            additionalScopes: scopes
        )
        
        try await authAccessTokenManager.saveAccessToken(signInResult.user.accessToken.tokenString)
    }
    
    func restoreUserSession() async throws -> GIDGoogleUser {
        if let currentUser {
            return currentUser
        } else {
            return try await signInInstance.restorePreviousSignIn()
        }
    }
}
