//
//  UIViewController + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

extension UIViewController: Presentable {
    var toPresent: UIViewController? { self }
    
    func showAlert(
        title: String?,
        message: String? = nil,
        actions: [UIAlertAction] = [], completion: VoidClosure? = nil) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            actions.forEach(alert.addAction)
            present(alert, animated: true, completion: completion)
    }
}
