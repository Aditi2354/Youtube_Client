//
//  UIView + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

extension UIView {
    enum BorderPosition {
        case top
        case bottom
    }

    func addBorder(color: UIColor = Resources.Colors.secondaryBackground,
                   height: CGFloat = 2,
                   position: BorderPosition) {
        let borderView = UIView()
        borderView.backgroundColor = color
        
        addSubview(borderView)
        
        borderView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(height)
            
            switch position {
            case .top:
                make.bottom.equalToSuperview(\.snp.top)
            case .bottom:
                make.top.equalToSuperview(\.snp.bottom)
            }
        }
    }
}

extension UIView {
    enum GradientPoint {
        case center
        case top
        case leading
        case trailing
        case bottom
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing

        var cgPoint: CGPoint {
            switch self {
            case .center: return CGPoint(x: 0.5, y: 0.5)
            case .top: return CGPoint(x: 0.5, y: 0)
            case .bottom: return CGPoint(x: 0.5, y: 1)
            case .leading: return CGPoint(x: 0, y: 0.5)
            case .trailing: return CGPoint(x: 1, y: 0.5)
            case .topLeading: return CGPoint(x: 0, y: 0)
            case .topTrailing: return CGPoint(x: 1, y: 0)
            case .bottomLeading: return CGPoint(x: 0, y: 1)
            case .bottomTrailing: return CGPoint(x: 1, y: 1)
            }
        }
    }
}
