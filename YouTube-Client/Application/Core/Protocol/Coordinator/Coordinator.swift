//
//  Coordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

protocol Coordinator: AnyObject {
    
    /// Starts the flow of this coordinator
    /// - Parameter item: Data that is needed to run flow
    func start(with item: Any?)
}
