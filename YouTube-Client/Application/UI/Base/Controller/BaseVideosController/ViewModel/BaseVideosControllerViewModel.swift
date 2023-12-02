//
//  BaseVideosControllerViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import Foundation
import Combine

/// A protocol that provides an interface for working with the View Model of the ``BaseVideosController``
protocol BaseVideosControllerViewModel {
    var userSessionRestorePublisher: AnyPublisher<Void, Never> { get }
    var userProfileImageURL: URL? { get }
    func showUserProfilePage()
    func showSearchPage()
}
