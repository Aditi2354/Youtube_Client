//
//  CoordinatorsFactory.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

protocol CoordinatorsFactory {
    func makeApplicationCoordinator(router: Router, googleOAuthAccessTokenManager: GoogleOAuthAccessTokenManager) -> Coordinator
    func makeAuthCoordinator(router: Router) -> AuthCoordinator
    func makeMainCoordinator(router: Router) -> MainCoordinator
    func makeHomepageCoordinator(router: Router) -> HomepageCoordinator
    func makeShortsCoordinator(router: Router) -> ShortsCoordinator
    func makeSubscriptionsCoordinator(router: Router) -> SubscriptionsCoordinator
    func makeUserLibraryCoordinator(router: Router) -> UserLibraryCoordinator
    func makeUserProfileCoordinator(router: Router) -> UserProfileCoordinator
    func makeSearchCoordinator(router: Router) -> SearchCoordinator
}
