//
//  Colors.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit

extension Resources {
    enum Colors {
        static var background: UIColor? {
            UIColor(named: "Background")
        }
        
        static var secondaryBackground: UIColor {
            .secondarySystemBackground
        }
        
        static var secondaryText: UIColor {
            .secondaryLabel
        }
        
        static var menuItem: UIColor? {
            UIColor(named: "MenuItemColor")
        }
        
        static var red: UIColor {
            UIColor.red
        }
        
        static var pinkGradient: [UIColor] {
            [
                UIColor("#FFFD35"),
                UIColor("#FF9352"),
                UIColor("#FF695E"),
                UIColor("#FF5863"),
                UIColor("#FF4469"),
                UIColor("#FF2771"),
                UIColor("#FF007C")
            ]
        }
    }
}
