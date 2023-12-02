//
//  AssemblyBuilder.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import GoogleSignIn
import GoogleAPIClientForREST_YouTube

/// A protocol that provides an interface for building individual application modules
protocol AssemblyBuilder {
    func buildAuthModule(coordinator: AuthCoordinator) -> Presentable
    
    func buildMainModule(coordinator: MainCoordinator) -> Presentable
    
    func buildHomepageModule(coordinator: HomepageCoordinator) -> Presentable
    
    func buildShortsModule(coordinator: ShortsCoordinator) -> Presentable
    
    func buildSubscriptionsModule(coordinator: SubscriptionsCoordinator) -> Presentable
    
    func buildUserLibraryModule(coordinator: UserLibraryCoordinator) -> Presentable
    
    func buildVideoViewingPageModule(videoPreviewModel: YouTubeVideoPreview, channel: GTLRYouTube_Channel) -> Presentable
    
    func buildUserProfileModule(user: GIDGoogleUser, coordinator: UserProfileCoordinator) -> Presentable
    
    func buildSearchModule(coordinator: SearchCoordinator) -> Presentable
}
