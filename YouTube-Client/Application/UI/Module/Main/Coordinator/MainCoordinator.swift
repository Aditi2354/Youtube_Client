//
//  MainCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import GoogleSignIn

/// Protocol of the Main module flow coordinator
protocol MainCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
    func showUserProfilePage(for user: GIDGoogleUser)
    func runSearchFlow()
}
