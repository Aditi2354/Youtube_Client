//
//  DI.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

/// A class for establishing dependency injection of entities used in the project.
///
/// Use it for dependency injection, which will be performed when the application is launched.
/// Create an instance of this class at application startup to have a ready-made dependency assembly for the entire application.
///
final class DI {
    
    //MARK: Properties
    
    private let assemblyBuilder: AssemblyBuilder
    private let coordinatorsFactory: CoordinatorsFactory
    let googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager
    let googleAuthService: GoogleAuthService
    let urlBuilder: URLBuilder
    let youTubeAPIService: YouTubeAPIService
    
    //MARK: - Initialization
    
    init() {
        assemblyBuilder = AssemblyBuilderImpl()
        coordinatorsFactory = CoordinatorsFactoryImpl(assemblyBuilder: assemblyBuilder)
        googleOAuthAccessTokenManager = GoogleOAuthAccessTokenManagerImpl()
        googleAuthService = GoogleAuthServiceImpl(authAccessTokenManager: googleOAuthAccessTokenManager)
        urlBuilder = URLBuilderImpl()
        youTubeAPIService = YouTubeAPIServiceImpl()
        
        if let builder = assemblyBuilder as? AssemblyBuilderImpl {
            builder.di = self
        }
    }
}

//MARK: - AppFactory

extension DI: AppFactory {
    func makeKeyWindowAndCoordinator(with windowScene: UIWindowScene) -> (window: UIWindow, coordinator: Coordinator) {
        let window = UIWindow(windowScene: windowScene)
        
        let router = RouterImpl(rootViewController: UINavigationController())
        let applicationCoordinator = coordinatorsFactory.makeApplicationCoordinator(router: router, googleOAuthAccessTokenManager: googleOAuthAccessTokenManager)
        
        window.rootViewController = router.toPresent
        window.makeKeyAndVisible()
        
        return (window, applicationCoordinator)
    }
}
