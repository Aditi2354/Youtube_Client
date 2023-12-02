//
//  ApplicationCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import GoogleSignIn

/// The main coordinator of the application, responsible for
/// launching the main flow and showing certain flows under certain conditions
///
/// Use this class to launch the main flow of the application and adjust
/// which flow should be launched under specific conditions.
/// Flow should be launched from this coordinator when the application itself is launched
final class ApplicationCoordinator: BaseCoordinatorImpl {
    
    //MARK: Properties
    
    private let router: Router
    private let coordinatorsFactory: CoordinatorsFactory
    private let assemblyBuilder: AssemblyBuilder
    private let googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager
    
    //MARK: - Initialization
    
    init(router: Router,
         coordinatorsFactory: CoordinatorsFactory,
         assemblyBuilder: AssemblyBuilder,
         googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager) {
        self.router = router
        self.coordinatorsFactory = coordinatorsFactory
        self.assemblyBuilder = assemblyBuilder
        self.googleOAuthAccessTokenManager = googleOAuthAccessTokenManager
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        Task {
            if await checkAuthentication() {
                await runMainFlow()
            } else {
                await runAuthFlow()
            }
        }
    }
}

//MARK: - Private methods

private extension ApplicationCoordinator {
    @MainActor
    func runAuthFlow() {
        let authCoordinator = coordinatorsFactory.makeAuthCoordinator(router: router)
        
        authCoordinator.finishFlow = { [weak self, weak authCoordinator] in
            guard let authCoordinator else { return }
            self?.removeDependency(with: authCoordinator)
            self?.start(with: nil)
        }
        
        addDependency(with: authCoordinator)
        authCoordinator.start(with: nil)
    }
    
    @MainActor
    func runMainFlow() {
        let mainCoordinator = coordinatorsFactory.makeMainCoordinator(router: router)
        
        mainCoordinator.finishFlow = { [weak self, weak mainCoordinator] in
            guard let mainCoordinator else { return }
            self?.removeDependency(with: mainCoordinator)
            self?.start(with: nil)
        }
        
        addDependency(with: mainCoordinator)
        mainCoordinator.start(with: nil)
    }
    
    func checkAuthentication() async -> Bool {
        (try? await googleOAuthAccessTokenManager.retrieveAccessToken()) != nil
    }
}
