//
//  ChannelProfileCVCellViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 16.06.2023.
//

import Foundation

protocol ChannelProfileCVCellViewModel: AnyObject {
    var channelProfileImageURL: URL? { get }
    var channelTitle: String { get }
}
