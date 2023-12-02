//
//  VideoPreviewCellViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 09.05.2023.
//

import Foundation
import GoogleAPIClientForREST_YouTube

final class VideoPreviewCellViewModelImpl: VideoPreviewCellViewModel {
    
    //MARK: Properties
    
    var videoID: String {
        videoPreview.id ?? ""
    }
    
    var title: String {
        videoPreview.title ?? ""
    }
    
    var previewInfo: String {
        let channelTitle = videoPreview.channel?.title ?? ""
        let passedTime = videoPreview.publishedAt?.passedTimeRelativeToNowString ?? ""
        
        return [channelTitle, passedTime].joined(separator: " • ")
    }
    
    var thumbnailImageURL: URL? {
        URL(string: videoPreview.thumbnailURL ?? "")
    }
    
    var channelProfileThumbnailURL: URL? {
        guard let urlString = channel?.snippet?.thumbnails?.medium?.url else {
            return nil
        }
        return URL(string: urlString)
    }
    
    private let videoPreview: YouTubeVideoPreview
    private let youTubeAPIService: YouTubeAPIService
    private(set) var channel: GTLRYouTube_Channel?
    
    //MARK: - Initialization
    
    init(videoPreview: YouTubeVideoPreview,
         youTubeAPIService: YouTubeAPIService) {
        self.videoPreview = videoPreview
        self.youTubeAPIService = youTubeAPIService
    }
    
    //MARK: - Methods
    
    func getChannelInfo() async throws {
        guard let id = videoPreview.channel?.id else { return }
        channel = try await youTubeAPIService.getChannel(id: id)
    }
}
