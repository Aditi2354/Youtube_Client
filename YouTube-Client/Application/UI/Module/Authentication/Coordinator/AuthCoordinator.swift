//
//  AuthCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

protocol AuthCoordinator: AnyObject where Self: Coordinator {
    var finishFlow: VoidClosure? { get set }
    func performCoordinate(for action: AuthCoordinateAction)
}
