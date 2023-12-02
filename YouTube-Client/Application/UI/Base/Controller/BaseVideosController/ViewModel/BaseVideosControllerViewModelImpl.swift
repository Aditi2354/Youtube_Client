//
//  BaseVideosControllerViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import Foundation
import GoogleSignIn
import Combine

/// View Model implementation for the ``BaseVideosController``
final class BaseVideosControllerViewModelImpl: BaseVideosControllerViewModel {
    
    //MARK: Properties
    
    var userSessionRestorePublisher: AnyPublisher<Void, Never> {
        $user
            .receive(on: DispatchQueue.main)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    var userProfileImageURL: URL? {
        user?.profile?.imageURL(withDimension: 25)
    }
    
    @Published private var user: GIDGoogleUser?
    
    //MARK: - Initialization
    
    init() {
        makeBindings()
    }
    
    //MARK: - Methods
    
    func restorePreviousSignIn() async throws {
        let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        self.user = user
    }
    
    func showUserProfilePage() {
        guard let user else { return }
        NotificationCenter.default.post(name: .YTClientOpenUserProfilePage, object: user)
    }
    
    func showSearchPage() {
        NotificationCenter.default.post(name: .YTClientOpenSearchPage, object: nil)
    }
}

//MARK: - Private methods

private extension BaseVideosControllerViewModelImpl {
    func makeBindings() {
        NotificationCenter.default.publisher(for: .GoogleUserSessionRestore)
            .receive(on: DispatchQueue.main)
            .compactMap { $0.object as? GIDGoogleUser }
            .assign(to: &$user)
    }
}
