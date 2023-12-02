//
//  CircleImageView.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 02.05.2023.
//

import UIKit

class CircleImageView: UIImageView {
    
    //MARK: - View Lyfecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
}
