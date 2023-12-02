//
//  UserProfileViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 15.06.2023.
//

import Foundation

/// A protocol that provides an interface for working with the View Model of the "User Profile" View Controller
protocol UserProfileViewModel: AnyObject {
    var profileImageURL: URL? { get }
    var username: String { get }
    var userEmail: String { get }
    func closePage()
    func signOut()
}
