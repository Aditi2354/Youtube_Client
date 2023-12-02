//
//  BaseCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

/// Implementation of the basic coordinator
///
/// Implements the basic functionality of creating and breaking the dependencies of coordinators with each other
///
class BaseCoordinatorImpl: BaseCoordinator {
    
    //MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    
    //MARK: - Methods
    
    func start(with item: Any?) { }
    
    func addDependency(with coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(with coordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        
        if let baseCoordinator = coordinator as? BaseCoordinatorImpl {
            baseCoordinator.childCoordinators
                .filter { $0 !== coordinator }
                .forEach(baseCoordinator.removeDependency)
        }
        
        for (index, child) in childCoordinators.enumerated() where child === coordinator { 
            childCoordinators.remove(at: index)
        }
    }
}
