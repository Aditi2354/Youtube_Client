//
//  VideoPreviewCellViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 09.05.2023.
//

import Foundation

protocol VideoPreviewCellViewModel: AnyObject {
    var videoID: String { get }
    var title: String { get }
    var previewInfo: String { get }
    var thumbnailImageURL: URL? { get }
    var channelProfileThumbnailURL: URL? { get }
    
    func getChannelInfo() async throws
}
