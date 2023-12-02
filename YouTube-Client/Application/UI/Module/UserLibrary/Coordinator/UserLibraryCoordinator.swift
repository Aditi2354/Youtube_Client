//
//  UserLibraryCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// A protocol of the "User Library" module flow coordinator
protocol UserLibraryCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
}
