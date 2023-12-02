//
//  MainViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// A protocol that provides an interface for working with the View Model of the main flow controller
protocol MainViewModel: AnyObject {
    func restoreUserSession() async throws
}
