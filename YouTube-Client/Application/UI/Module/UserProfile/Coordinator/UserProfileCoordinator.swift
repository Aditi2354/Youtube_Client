//
//  UserProfileCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 15.06.2023.
//

/// A protocol of the "User Profile" module flow coordinator
protocol UserProfileCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
    var finishFlowOnSignOut: VoidClosure? { get set }
    func performCoordinate(for action: UserProfileCoordinateAction)
}
