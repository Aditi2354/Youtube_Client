//
//  AppFactory.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

/// A protocol that provides an interface for configuring the application window and
/// its main coordinator, from which the initial flow starts
protocol AppFactory {
    
    /// Creates a window for a given scene and the main coordinator from which the main flow of the application begins.
    ///
    /// Use to assign a key application window in the SceneDelegate class and launch the flow of the application coordinator
    /// 
    /// - Parameter windowScene: A scene that manages one or more windows for your app.
    /// - Returns: A tuple with a window for a given scene and a main coordinator
    func makeKeyWindowAndCoordinator(with windowScene: UIWindowScene) -> (window: UIWindow, coordinator: Coordinator)
}
