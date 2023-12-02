//
//  SearchCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 01.07.2023.
//

protocol SearchCoordinator: VideoPresentingCoordinator {
    var finishFlow: VoidClosure? { get set }
    func performCoordinate(for action: SearchCoordinateAction)
}
