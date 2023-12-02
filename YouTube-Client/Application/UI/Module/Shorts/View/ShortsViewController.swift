//
//  ShortsViewController.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit

/// The View Controller of the "Shorts" module
final class ShortsViewController: BaseShortsController, ViewModelBindable {
    
    typealias ViewModel = ShortsViewModel
    
    var viewModel: ViewModel!
}
