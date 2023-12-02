//
//  GoogleOAuthAccessTokenManagerImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import Foundation
import Security

/// Implementation of Google OAuth Access Token Manager
actor GoogleOAuthAccessTokenManagerImpl: GoogleOAuthAccessTokenManager {
    
    enum OAuthAccessTokenError: LocalizedError {
        case unsuccessfulOperation
        case unableToGetData
        case tokenNotFound
    }
    
    //MARK: Properties
    
    private let accessTokenAccountName = "google_access_token"
    
    //MARK: - Methods
    
    func saveAccessToken(_ accessToken: String) async throws {
        guard let accessTokenData = accessToken.data(using: .utf8) else {
            throw OAuthAccessTokenError.unableToGetData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenAccountName,
            kSecValueData as String: accessTokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw OAuthAccessTokenError.unsuccessfulOperation
        }
    }
    
    func retrieveAccessToken() async throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenAccountName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            throw OAuthAccessTokenError.unsuccessfulOperation
        }
        
        guard
            let tokenData = item as? Data,
            let token = String(data: tokenData, encoding: .utf8)
        else {
            throw OAuthAccessTokenError.unableToGetData
        }
        
        return token
    }
    
    func deleteAccessToken() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accessTokenAccountName
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw OAuthAccessTokenError.unsuccessfulOperation
        }
        
        guard status == errSecItemNotFound else {
            throw OAuthAccessTokenError.tokenNotFound
        }
    }
}

