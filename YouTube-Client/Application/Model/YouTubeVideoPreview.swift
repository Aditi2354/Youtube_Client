//
//  YouTubeVideoPreview.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 09.05.2023.
//

import GoogleAPIClientForREST_YouTube

struct YouTubeVideoPreview: Hashable {
    
    struct ChannelPreview: Hashable {
        let id: String?
        let title: String?
    }
    
    //MARK: Properties
    
    let id: String?
    let channel: ChannelPreview?
    let title: String?
    let publishedAt: Date?
    let thumbnailURL: String?
    
    //MARK: - Initialization
    
    init(id: String?,
         channel: ChannelPreview?,
         title: String?,
         publishedAt: Date?,
         thumbnailURL: String?) {
        self.id = id
        self.channel = channel
        self.title = title
        self.publishedAt = publishedAt
        self.thumbnailURL = thumbnailURL
    }
    
    init(searchResult: GTLRYouTube_SearchResult?) {
        self.id = searchResult?.identifier?.videoId
        self.channel = ChannelPreview(
            id: searchResult?.snippet?.channelId,
            title: searchResult?.snippet?.channelTitle
        )
        self.title = searchResult?.snippet?.title
        self.publishedAt = searchResult?.snippet?.publishedAt?.date
        self.thumbnailURL = searchResult?.snippet?.thumbnails?.high?.url
    }
}
