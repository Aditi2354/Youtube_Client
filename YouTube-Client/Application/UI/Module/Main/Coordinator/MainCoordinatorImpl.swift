//
//  MainCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import UIKit
import GoogleSignIn

/// Main coordinator implementation
final class MainCoordinatorImpl: BaseCoordinatorImpl, MainCoordinator {
    
    //MARK: Properties
    
    var finishFlow: VoidClosure?
    
    private let router: Router
    private let coordinatorsFactory: CoordinatorsFactory
    private let assemblyBuilder: AssemblyBuilder
    
    private weak var tabBarController: UITabBarController?
    
    //MARK: - Initialization
    
    init(router: Router,
         coordinatorsFactory: CoordinatorsFactory,
         assemblyBuilder: AssemblyBuilder) {
        self.router = router
        self.coordinatorsFactory = coordinatorsFactory
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        let module = assemblyBuilder.buildMainModule(coordinator: self)
        
        guard let tabBarController = module.toPresent as? UITabBarController else { return }
        
        self.tabBarController = tabBarController
        setupAndStartChildCoordinators()
        
        router.setRootModule(module, animated: true, hideBar: true)
    }
    
    func showUserProfilePage(for user: GIDGoogleUser) {
        let coordinator = coordinatorsFactory.makeUserProfileCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let coordinator else { return }
            self?.removeDependency(with: coordinator)
        }
        
        coordinator.finishFlowOnSignOut = { [weak self] in
            self?.removeAllDependencies()
            self?.finishFlow?()
        }
        
        addDependency(with: coordinator)
        coordinator.start(with: user)
    }
    
    func runSearchFlow() {
        let coordinator = coordinatorsFactory.makeSearchCoordinator(router: router)
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard let coordinator else { return }
            self?.removeDependency(with: coordinator)
        }
        
        addDependency(with: coordinator)
        coordinator.start(with: nil)
    }
}

//MARK: - Private methods

private extension MainCoordinatorImpl {
    
    /// This method creates and starts a coordinator for each tab, making it a child
    func setupAndStartChildCoordinators() {
        guard let navigationControllers = tabBarController?.viewControllers as? [UINavigationController] else {
            return
        }
        
        for navigationController in navigationControllers {
            guard let tab = TabBarTabs(rawValue: navigationController.tabBarItem.tag) else { return }
            
            let coordinatorRouter = RouterImpl(rootViewController: navigationController)
            
            var coordinator: Coordinator!
            
            switch tab {
            case .homepage:
                let homeCoordinator = coordinatorsFactory.makeHomepageCoordinator(router: coordinatorRouter)
                
                homeCoordinator.finishFlow = { [weak self, weak homeCoordinator] in
                    guard let homeCoordinator else { return }
                    self?.removeDependency(with: homeCoordinator)
                }
                coordinator = homeCoordinator
            case .shorts:
                let shortsCoordinator = coordinatorsFactory.makeShortsCoordinator(router: coordinatorRouter)
                
                shortsCoordinator.finishFlow = { [weak self, weak shortsCoordinator] in
                    guard let shortsCoordinator else { return }
                    self?.removeDependency(with: shortsCoordinator)
                }
                coordinator = shortsCoordinator
            case .addVideo:
                break
            case .subscriptions:
                let subscriptionsCoordinator = coordinatorsFactory.makeSubscriptionsCoordinator(router: coordinatorRouter)
                
                subscriptionsCoordinator.finishFlow = { [weak self, weak subscriptionsCoordinator] in
                    guard let subscriptionsCoordinator else { return }
                    self?.removeDependency(with: subscriptionsCoordinator)
                }
                
                coordinator = subscriptionsCoordinator
            case .library:
                let userLibraryCoordinator = coordinatorsFactory.makeUserLibraryCoordinator(router: coordinatorRouter)
                
                userLibraryCoordinator.finishFlow = { [weak self, weak userLibraryCoordinator] in
                    guard let userLibraryCoordinator else { return }
                    self?.removeDependency(with: userLibraryCoordinator)
                }
                coordinator = userLibraryCoordinator
            }
            
            if tab != .addVideo {
                addDependency(with: coordinator)
                coordinator.start(with: nil)
            }
        }
    }
    
    func removeAllDependencies() {
        childCoordinators.forEach { coordinator in
            switch coordinator {
            case let homepageCoordinator as HomepageCoordinator:
                homepageCoordinator.finishFlow?()
            case let shortsCoordinator as ShortsCoordinator:
                shortsCoordinator.finishFlow?()
            case let subscriptionsCoordinator as SubscriptionsCoordinator:
                subscriptionsCoordinator.finishFlow?()
            case let userLibraryCoordinator as UserLibraryCoordinator:
                userLibraryCoordinator.finishFlow?()
            default:
                break
            }
        }
    }
}
