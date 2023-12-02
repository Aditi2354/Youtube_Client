//
//  Router.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

/// A protocol that provides an interface of methods for transitions between application screens
///
/// Use this protocol to implement transition methods between application screens as a separate layer
protocol Router: Presentable {
    
    /// Modally presents the screen of the transmitted module
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - fullScreenDisplay: Pass true to show the module in full screen; otherwise pass false.
    func present(_ module: Presentable, animated: Bool, fullScreenDisplay: Bool)
    
    
    /// Modally represents the screen of the transmitted module and performs the transmitted completion
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - fullScreenDisplay: Pass true to show the module in full screen; otherwise pass false.
    ///   - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func present(_ module: Presentable, animated: Bool, fullScreenDisplay: Bool, completion: VoidClosure?)
    
    
    /// Pushes a view controller onto the receiver’s stack and updates the display.
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: Specify true to animate the transition or false if you do not want the transition to be animated. You might specify false if you are setting up the navigation controller at launch time.
    func push(_ module: Presentable, animated: Bool)
    
    
    /// Puts the viewing controller on the receiver stack and updates the display with the ability to hide the bottom bar
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: Specify true to animate the transition or false if you do not want the transition to be animated. You might specify false if you are setting up the navigation controller at launch time.
    ///   - hideBottomBar: Pass true to hide the bottom panel; otherwise pass false
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool)
    
    
    /// Puts the viewing controller on the receiver stack and updates the display with the ability to hide the bottom bar
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: Specify true to animate the transition or false if you do not want the transition to be animated. You might specify false if you are setting up the navigation controller at launch time.
    ///   - hideBottomBar: Pass true to hide the bottom panel; otherwise pass false
    ///   - completion: The block to execute after the transferred module is removed from the navigation stack
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool, completion: VoidClosure?)
    
    
    /// Pops the top module from the navigation stack and updates the display.
    /// - Parameter animated: Set this value to true to animate the transition; otherwise pass false.
    func popModule(animated: Bool)
    
    
    /// Dismisses the module that was presented modally by the view controller.
    /// - Parameter animated: Pass true to animate the transition.
    func dismissModule(animated: Bool)
    
    
    /// Dismisses the module that was presented modally by the view controller and performs the transmitted completion
    /// - Parameters:
    ///   - animated: Pass true to animate the transition.
    ///   - completion: The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func dismissModule(animated: Bool, completion: VoidClosure?)
    
    
    /// Replaces the modules currently managed by the navigation controller with the specified module.
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: If true, animate the pushing or popping of the top view controller. If false, replace the view controllers without any animations.
    func setRootModule(_ module: Presentable, animated: Bool)
    
    
    /// Replaces the modules currently managed by the navigation controller with the specified module.
    /// - Parameters:
    ///   - module: Abstraction over a UIViewController to represent an application module
    ///   - animated: If true, animate the pushing or popping of the top view controller. If false, replace the view controllers without any animations.
    ///   - hideBar: If the value is true, the navigation bar in the specified module will be hidden.
    func setRootModule(_ module: Presentable, animated: Bool, hideBar: Bool)
    
    
    /// Pops all the modules on the stack except the root module and updates the display.
    /// - Parameter animated: Set this value to true to animate the transition.
    func popToRootModule(animated: Bool)
}
