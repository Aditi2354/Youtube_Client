//
//  VideoViewingPageViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 16.05.2023.
//

import Foundation

protocol VideoViewingPageViewModel: ObservableObject {
    var isInfoLoaded: Bool { get }
    var videoTitle: String { get }
    var thumbnailImageURL: URL? { get }
    var viewsCount: String { get }
    var likesCount: String { get }
    var commentsCount: Int { get }
    var publishedAt: String { get }
    var channelTitle: String { get }
    var channelProfileThumbnailURL: URL? { get }
    var channelSubscribersCount: String { get }
    var comments: [YouTubeComment] { get }
    
    func fetchInfo() async throws
}
