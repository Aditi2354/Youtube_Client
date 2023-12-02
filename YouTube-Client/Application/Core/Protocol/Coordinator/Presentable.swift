//
//  Presentable.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 26.04.2023.
//

import UIKit

protocol Presentable: AnyObject {
    var toPresent: UIViewController? { get }
}
