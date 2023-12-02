//
//  UserProfileCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 15.06.2023.
//

import UIKit
import GoogleSignIn

enum UserProfileCoordinateAction {
    case pageClose
    case signOut
}

/// "User Profile" module flow coordinator implementation
final class UserProfileCoordinatorImpl: BaseCoordinatorImpl, UserProfileCoordinator {

    //MARK: Properties
    
    var finishFlow: VoidClosure?
    var finishFlowOnSignOut: VoidClosure?
    
    private let router: Router
    private let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(router: Router, assemblyBuilder: AssemblyBuilder) {
        self.router = router
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        guard let user = item as? GIDGoogleUser else { return }
        let module = assemblyBuilder.buildUserProfileModule(user: user, coordinator: self)
        
        guard let presentableModule = module.toPresent else { return }
        router.present(
            UINavigationController(rootViewController: presentableModule),
            animated: true,
            fullScreenDisplay: true
        )
    }
    
    func performCoordinate(for action: UserProfileCoordinateAction) {
        switch action {
        case .pageClose:
            closePageAndFinishFlow()
        case .signOut:
            makeSignOutCoordination()
        }
    }
}

//MARK: - Private methods

private extension UserProfileCoordinatorImpl {
    func closePageAndFinishFlow() {
        finishFlow?()
        router.dismissModule(animated: true)
    }
    
    func makeSignOutCoordination() {
        finishFlow?()
        finishFlowOnSignOut?()
        router.dismissModule(animated: true)
    }
}
