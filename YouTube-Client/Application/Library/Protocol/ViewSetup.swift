//
//  ViewSetup.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

import UIKit

/// A protocol that provides an interface for working with internal views.
///
///  Use this protocol to get an interface that allows you to implement
///  and logically separate the following functions:
///  - Adding child views and their primary configuration.
///  - Configuring the appearance of views.
///  - Setting constraints and the location of views on the screen.
///
protocol ViewSetup: AnyObject {
    func configureAppearance()
    func setupSubviews()
    func makeSubviewsLayout()
}
