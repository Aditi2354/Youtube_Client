//
//  MainTabBarController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit

//MARK: TabBarTabs

/// Main tab bar controller tabs
enum TabBarTabs: Int, CaseIterable {
    case homepage
    case shorts
    case addVideo
    case subscriptions
    case library
}

//MARK: - MainTabBarController

final class MainTabBarController: UITabBarController, ViewModelBindable {
    
    typealias ViewModel = MainViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel!

    //MARK: - View Controller Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setViewControllers(makeTabsNavigationControllers(), animated: false)
        restoreUserSession()
    }
}

//MARK: - Private methods

private extension MainTabBarController {
    func configure() {
        delegate = self
        view.backgroundColor = Resources.Colors.background
        tabBar.addBorder(position: .top)
        tabBar.tintColor = Resources.Colors.red
        tabBar.unselectedItemTintColor = .label
        tabBar.isTranslucent = false
        tabBar.barTintColor = Resources.Colors.background
        tabBar.backgroundColor = Resources.Colors.background
    }
    
    func restoreUserSession() {
        Task {
            do {
                try await viewModel.restoreUserSession()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeTabsNavigationControllers() -> [UINavigationController] {
        var navigationControllers = [UINavigationController]()
        
        TabBarTabs.allCases.forEach { tab in
            navigationControllers.append(setupNavigationController(for: tab))
        }
        
        return navigationControllers
    }
    
    func setupNavigationController(for tab: TabBarTabs) -> UINavigationController {
        var navigationController: UINavigationController!
        
        switch tab {
        case .homepage:
            navigationController = makeTabNavigationController(
                title: Resources.Strings.TabBar.home,
                tabBarImage: Resources.Images.TabBar.Default.home,
                tabBarSelectedImage: Resources.Images.TabBar.Active.home
            )
        case .shorts:
            navigationController = makeTabNavigationController(
                title: Resources.Strings.TabBar.shorst,
                tabBarImage: Resources.Images.TabBar.Default.shorst,
                tabBarSelectedImage: Resources.Images.TabBar.Active.shorst
            )
        case .addVideo:
            navigationController = makeNavigationControllerForAddTab()
        case .subscriptions:
            navigationController = makeTabNavigationController(
                title: Resources.Strings.TabBar.subscriptions,
                tabBarImage: Resources.Images.TabBar.Default.subscriptions,
                tabBarSelectedImage: Resources.Images.TabBar.Active.subscriptions
            )
        case .library:
            navigationController = makeTabNavigationController(
                title: Resources.Strings.TabBar.library,
                tabBarImage: Resources.Images.TabBar.Default.library,
                tabBarSelectedImage: Resources.Images.TabBar.Active.library
            )
        }
        
        navigationController.tabBarItem.tag = tab.rawValue
        
        return navigationController
    }
    
    func makeNavigationControllerForAddTab() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = Resources.Colors.background
        navigationController.tabBarItem.image = Resources.Images.TabBar.add
        navigationController.tabBarItem.imageInsets = .init(top: 4, left: 0, bottom: -8, right: 0)
        navigationController.tabBarItem.title = nil
        return navigationController
    }

    func makeTabNavigationController(title: String,
                                   tabBarImage: UIImage?,
                                   tabBarSelectedImage: UIImage?) -> UINavigationController {
        let navigationController = BaseNavigationController()
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = tabBarImage
        navigationController.tabBarItem.selectedImage = tabBarSelectedImage
        return navigationController
    }
}

//MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard
            let tab = TabBarTabs(rawValue: viewController.tabBarItem.tag),
            tab != .addVideo
        else {
            return false
        }
        
        return true
    }
}
