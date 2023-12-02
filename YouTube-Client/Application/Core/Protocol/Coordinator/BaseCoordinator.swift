//
//  BaseCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

protocol BaseCoordinator: Coordinator {
    
    /// List of child coordinators
    var childCoordinators: [Coordinator] { get }
    
    /// Adds a dependency with another coordinator and keeps it as a child
    /// - Parameter coordinator: Another coordinator to create a dependency with
    func addDependency(with coordinator: Coordinator)
    
    /// Removes the dependency between this coordinator and the one passed to the method parameter
    /// - Parameter coordinator: Another coordinator to break the connection with
    func removeDependency(with coordinator: Coordinator)
}
