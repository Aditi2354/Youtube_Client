//
//  GoogleAuthService.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import GoogleSignIn

protocol GoogleAuthService {
    
    var currentUser: GIDGoogleUser? { get }
    
    /// Logs in using a Google account
    /// - Parameter presenting: View Controller from which the Google authorization window will open
    func signIn(presenting: Presentable) async throws
    
    func restoreUserSession() async throws -> GIDGoogleUser
}
