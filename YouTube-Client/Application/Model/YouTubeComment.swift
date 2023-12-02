//
//  YouTubeComment.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import Foundation
import GoogleAPIClientForREST_YouTube

struct YouTubeComment: Identifiable, Hashable {
    
    //MARK: Properties
    
    let id = UUID()
    
    let authorChannelId: String?
    let authorChannelURL: String?
    let authorName: String?
    let authorProfileImageURL: String?
    let likesCount: Int?
    let text: String?
    let updatedAt: Date?
    
    //MARK: - Initialization
    
    init(authorChannelId: String?,
         authorChannelURL: String?,
         authorName: String?,
         authorProfileImageURL: String?,
         likesCount: Int?,
         text: String?,
         updatedAt: Date?) {
        self.authorChannelId = authorChannelId
        self.authorChannelURL = authorChannelURL
        self.authorName = authorName
        self.authorProfileImageURL = authorProfileImageURL
        self.likesCount = likesCount
        self.text = text
        self.updatedAt = updatedAt
    }
    
    init(commentSnippet: GTLRYouTube_CommentSnippet) {
        self.init(
            authorChannelId: commentSnippet.channelId,
            authorChannelURL: commentSnippet.authorChannelUrl,
            authorName: commentSnippet.authorDisplayName,
            authorProfileImageURL: commentSnippet.authorProfileImageUrl,
            likesCount: commentSnippet.likeCount?.intValue,
            text: commentSnippet.textOriginal,
            updatedAt: commentSnippet.updatedAt?.date
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
