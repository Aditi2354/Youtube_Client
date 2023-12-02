//
//  CoordinatorsFactoryImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

/// Factory of Coordinators
final class CoordinatorsFactoryImpl: CoordinatorsFactory {

    //MARK: Properties
    
    private let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(assemblyBuilder: AssemblyBuilder) {
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func makeApplicationCoordinator(router: Router, googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager) -> Coordinator {
        ApplicationCoordinator(router: router, coordinatorsFactory: self, assemblyBuilder: assemblyBuilder, googleOAuthAccessTokenManager: googleOAuthAccessTokenManager)
    }
    
    func makeAuthCoordinator(router: Router) -> AuthCoordinator {
        AuthCoordinatorImpl(router: router, assemblyBuilder: assemblyBuilder)
    }
    
    func makeMainCoordinator(router: Router) -> MainCoordinator {
        MainCoordinatorImpl(router: router, coordinatorsFactory: self, assemblyBuilder: assemblyBuilder)
    }
    
    func makeHomepageCoordinator(router: Router) -> HomepageCoordinator {
        HomepageCoordinatorImpl(router: router, coordinatorsFactory: self, assemblyBuilder: assemblyBuilder)
    }
    
    func makeShortsCoordinator(router: Router) -> ShortsCoordinator {
        ShortsCoordinatorImpl(router: router, coordinatorsFactory: self, assemblyBuilder: assemblyBuilder)
    }
    
    func makeSubscriptionsCoordinator(router: Router) -> SubscriptionsCoordinator {
        SubscriptionsCoordinatorImpl(router: router, coordinatorsFactory: self, assemblyBuilder: assemblyBuilder)
    }
    
    func makeUserLibraryCoordinator(router: Router) -> UserLibraryCoordinator {
        UserLibraryCoordinatorImpl(router: router, coordinatorsFactory: self, assemblyBuilder: assemblyBuilder)
    }

    func makeUserProfileCoordinator(router: Router) -> UserProfileCoordinator {
        UserProfileCoordinatorImpl(router: router, assemblyBuilder: assemblyBuilder)
    }
    
    func makeSearchCoordinator(router: Router) -> SearchCoordinator {
        SearchCoordinatorImpl(router: router, assemblyBuilder: assemblyBuilder)
    }
}
