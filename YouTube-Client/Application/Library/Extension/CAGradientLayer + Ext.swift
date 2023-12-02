//
//  CAGradientLayer + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import UIKit

extension CAGradientLayer {
    convenience init(startPoint: UIView.GradientPoint, endPoint: UIView.GradientPoint, colors: [UIColor]? = nil) {
        self.init()
        self.startPoint = startPoint.cgPoint
        self.endPoint = endPoint.cgPoint
        self.colors = colors
    }
}
