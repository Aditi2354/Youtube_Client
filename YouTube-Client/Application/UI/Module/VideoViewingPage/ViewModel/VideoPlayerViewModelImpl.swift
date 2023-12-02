//
//  VideoPlayerViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 16.05.2023.
//

import Foundation
import GoogleAPIClientForREST_YouTube

final class VideoViewingPageViewModelImpl: VideoViewingPageViewModel {
    
    //MARK: Properties
    
    @Published var isInfoLoaded = false
    
    var videoTitle: String {
        videoPreviewModel.title ?? ""
    }
    
    var thumbnailImageURL: URL? {
        guard let imageURLString = videoPreviewModel.thumbnailURL else {
            return nil
        }
        return URL(string: imageURLString)
    }
    
    var viewsCount: String {
        guard let number = video?.statistics?.viewCount else { return "0 views" }
        return Int(truncating: number).formatPositiveNumberToDisplay() + " views"
    }
    
    var likesCount: String {
        guard let number = video?.statistics?.likeCount else { return "0" }
        return Int(truncating: number).formatPositiveNumberToDisplay()
    }
    
    var commentsCount: Int {
        guard let number = video?.statistics?.commentCount else { return 0 }
        return Int(truncating: number)
    }
    
    var publishedAt: String {
        videoPreviewModel.publishedAt?.passedTimeRelativeToNowString ?? ""
    }
    
    var channelTitle: String {
        videoPreviewModel.channel?.title ?? ""
    }
    
    var channelProfileThumbnailURL: URL? {
        guard let urlString = channel.snippet?.thumbnails?.medium?.url else {
            return nil
        }
        return URL(string: urlString)
    }
    
    var channelSubscribersCount: String {
        guard let count = channel.statistics?.subscriberCount else {
            return ""
        }
        return Int(truncating: count).formatPositiveNumberToDisplay()
    }
    
    private let videoPreviewModel: YouTubeVideoPreview
    private let youTubeAPIService: YouTubeAPIService
    private let channel: GTLRYouTube_Channel
    private var video: GTLRYouTube_Video?
    
    var comments: [YouTubeComment] = []
    
    //MARK: - Initialization
    
    init(videoPreviewModel: YouTubeVideoPreview,
         channel: GTLRYouTube_Channel,
         youTubeAPIService: YouTubeAPIService) {
        self.videoPreviewModel = videoPreviewModel
        self.channel = channel
        self.youTubeAPIService = youTubeAPIService
    }
    
    //MARK: - Methods
    
    @MainActor
    func fetchInfo() async throws {
        isInfoLoaded = false
        
        try await withThrowingTaskGroup(of: Void.self) { [weak self] group in
            guard let self else {
                self?.isInfoLoaded = false
                return
            }
            
            group.addTask {
                try await self.fetchVideoInfo()
            }
            
            group.addTask {
                try await self.fetchComments()
            }
            
            for try await _ in group { }
            
            isInfoLoaded = true
        }
    }
}

//MARK: - Private methods

private extension VideoViewingPageViewModelImpl {
    func fetchVideoInfo() async throws {
        guard
            let videoId = videoPreviewModel.id,
            let video = try await youTubeAPIService.getVideo(id: videoId)
        else {
            return
        }
        
        self.video = video
    }
    
    func fetchComments() async throws {
        guard let videoId = videoPreviewModel.id else { return }
        let comments = try await youTubeAPIService.getComments(videoId: videoId)
        self.comments = comments.compactMap { commentThread in
            guard let commentSnippet = commentThread.snippet?.topLevelComment?.snippet else {
                return nil
            }
            
            return YouTubeComment(commentSnippet: commentSnippet)
        }
    }
}
