//
//  AssemblyBuilderImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleAPIClientForREST_YouTube

/// Implements the assembly of application modules, initializing blocks
/// for each module corresponding to the current application architecture
final class AssemblyBuilderImpl: AssemblyBuilder {
 
    //MARK: Properties
    
    weak var di: DI!
    
    //MARK: - Methods
    
    func buildAuthModule(coordinator: AuthCoordinator) -> Presentable {
        let viewModel = AuthViewModelImpl(
            coordinator: coordinator,
            googleAuthService: di.googleAuthService
        )
        
        let view = AuthViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildMainModule(coordinator: MainCoordinator) -> Presentable {
        let viewModel = MainViewModelImpl(
            googleAuthService: di.googleAuthService,
            coordinator: coordinator
        )
        
        let view = MainTabBarController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildHomepageModule(coordinator: HomepageCoordinator) -> Presentable {
        let viewModel = HomepageViewModelImpl(
            coordinator: coordinator,
            youTubeAPIService: di.youTubeAPIService
        )
        
        let view = HomepageViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildShortsModule(coordinator: ShortsCoordinator) -> Presentable {
        let viewModel = ShortsViewModelImpl(coordinator: coordinator)
        
        let view = ShortsViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildSubscriptionsModule(coordinator: SubscriptionsCoordinator) -> Presentable {
        let viewModel = SubscriptionsViewModelImpl(
            youTubeAPIService: di.youTubeAPIService,
            coordinator: coordinator
        )
        
        let view = SubscriptionsViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildUserLibraryModule(coordinator: UserLibraryCoordinator) -> Presentable {
        let viewModel = UserLibraryViewModelImpl(coordinator: coordinator)
        
        let view = UserLibraryViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildVideoViewingPageModule(videoPreviewModel: YouTubeVideoPreview, channel: GTLRYouTube_Channel) -> Presentable {
        let viewModel = VideoViewingPageViewModelImpl(
            videoPreviewModel: videoPreviewModel,
            channel: channel,
            youTubeAPIService: di.youTubeAPIService
        )
        
        let view = VideoViewingPage<VideoViewingPageViewModelImpl>(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
    
    func buildUserProfileModule(user: GIDGoogleUser, coordinator: UserProfileCoordinator) -> Presentable {
        let viewModel = UserProfileViewModelImpl(
            user: user,
            googleOAuthAccessTokenManager: di.googleOAuthAccessTokenManager,
            coordinator: coordinator
        )
        
        let view = UserProfileViewController()
        view.viewModel = viewModel
        
        return view
    }
    
    func buildSearchModule(coordinator: SearchCoordinator) -> Presentable {
        let viewModel = SearchViewModelImpl(
            coordinator: coordinator,
            youTubeAPIService: di.youTubeAPIService
        )
        
        let view = SearchViewController()
        view.viewModel = viewModel
        
        return view
    }
}
