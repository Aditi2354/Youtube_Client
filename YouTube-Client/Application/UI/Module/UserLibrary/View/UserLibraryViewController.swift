//
//  UserLibraryViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit

/// The View Controller of the "User Library" module
final class UserLibraryViewController: BaseVideosController, ViewModelBindable {
    
    typealias ViewModel = UserLibraryViewModel
    
    var viewModel: ViewModel!
}
