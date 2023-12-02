//
//  ViewModelBindable.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

/// Protocol for assigning view models to views
///
/// Uses an associative type, which is the type of the view model for the view subscribed to this protocol
protocol ViewModelBindable: AnyObject {
    associatedtype ViewModel
    
    /// Instance of the view model
    var viewModel: ViewModel! { get set }
}

