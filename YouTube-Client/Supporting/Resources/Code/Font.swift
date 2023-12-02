//
//  Font.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 30.04.2023.
//

import UIKit

extension Resources {
    enum Fonts {
        enum FontStyle {
            case regular
            case medium
            case bold
            
            var fontSuffix: String {
                switch self {
                case .regular:
                    return ""
                case .medium:
                    return "-Medium"
                case .bold:
                    return "-Bold"
                }
            }
        }
        
        static func helveticaNeue(size: CGFloat, style: FontStyle) -> UIFont {
            UIFont(name: "HelveticaNeue" + style.fontSuffix, size: size)!
        }
    }
}
