//
//  GoogleOAuthAccessTokenManager.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

/// A protocol that provides methods for saving, receiving, and deleting a
/// Google OAuth access token using the Keychain
protocol GoogleOAuthAccessTokenManager {
    
    /// Saves the Google OAuth access token in the Keychain
    /// - Parameter accessToken: Access token to be saved
    func saveAccessToken(_ accessToken: String) async throws
    
    /// Retrieves the Google OAuth access token from the Keychain
    /// - Returns: Access token stored in the Keychain
    func retrieveAccessToken() async throws -> String
    
    /// Removes the Google OAuth access token from the keychain
    func deleteAccessToken() async throws
}
