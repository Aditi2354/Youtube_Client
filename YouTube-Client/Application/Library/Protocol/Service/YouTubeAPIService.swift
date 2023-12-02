//
//  YouTubeAPIService.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 08.05.2023.
//

import GoogleAPIClientForREST_YouTube

/// A protocol that provides an interface for the service to work with the YouTube API
protocol YouTubeAPIService {
    func search(query: GTLRYouTubeQuery_SearchList) async throws -> GTLRYouTube_SearchListResponse
    
    func getVideo(id: String) async throws -> GTLRYouTube_Video?
    
    func getVideosList(query: GTLRYouTubeQuery_VideosList) async throws -> [GTLRYouTube_Video]
    
    func getChannel(id: String) async throws -> GTLRYouTube_Channel?
    
    func getComments(videoId: String) async throws -> [GTLRYouTube_CommentThread]
    
    func getSubscriptions(maxResults: Int, nextPageToken: String?) async throws -> GTLRYouTube_SubscriptionListResponse
}
