//
//  RouterImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

final class RouterImpl: Router {
    
    //MARK: Properties
    
    var toPresent: UIViewController? {
        rootViewController
    }
    
    private var rootViewController: UINavigationController
    private var completionHandlers = [UIViewController: VoidClosure]()
    
    //MARK: - Initialization
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    //MARK: - Methods
    
    func present(_ module: Presentable, animated: Bool, fullScreenDisplay: Bool) {
        present(module, animated: animated, fullScreenDisplay: fullScreenDisplay, completion: nil)
    }
    
    func present(_ module: Presentable, animated: Bool, fullScreenDisplay: Bool, completion: VoidClosure?) {
        guard let viewController = module.toPresent else { return }
        viewController.modalPresentationStyle = fullScreenDisplay ? .fullScreen : .automatic
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable, animated: Bool) {
        push(module, animated: animated, hideBottomBar: false)
    }
    
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool) {
        push(module, animated: animated, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool, completion: VoidClosure?) {
        guard let viewController = module.toPresent else { return }

        guard (viewController as? UINavigationController) == nil else {
            fatalError("Pushing a navigation controller is not supported")
        }
        
        if let completion {
            completionHandlers[viewController] = completion
        }
        
        viewController.hidesBottomBarWhenPushed = hideBottomBar
        rootViewController.pushViewController(viewController, animated: animated)
    }
    
    func popModule(animated: Bool) {
        if let viewController = rootViewController.popViewController(animated: animated) {
            runCompletionHandler(for: viewController)
        }
    }
    
    func dismissModule(animated: Bool) {
        dismissModule(animated: animated, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: VoidClosure?) {
        rootViewController.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable, animated: Bool) {
        setRootModule(module, animated: animated, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable, animated: Bool, hideBar: Bool) {
        guard let viewController = module.toPresent else { return }
        rootViewController.setViewControllers([viewController], animated: animated)
        rootViewController.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        if let viewControllers = rootViewController.popToRootViewController(animated: animated) {
            viewControllers.forEach(runCompletionHandler)
        }
    }
}

//MARK: - Private methods

private extension RouterImpl {
    func runCompletionHandler(for viewController: UIViewController) {
        guard let completionHandler = completionHandlers[viewController] else { return }
        completionHandler()
        completionHandlers.removeValue(forKey: viewController)
    }
}
