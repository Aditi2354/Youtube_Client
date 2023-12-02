//
//  YouTubeSubscription.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 16.06.2023.
//

import Foundation
import GoogleAPIClientForREST_YouTube

struct YouTubeSubscription: Hashable {
    
    //MARK: Properties
    
    let channelId: String?
    let channelTitle: String?
    let channelDescription: String?
    let channelProfileImageURL: String?
    let subscriptionDate: Date?
    
    //MARK: - Initialization
    
    init(channelId: String? = nil,
         channelTitle: String? = nil,
         channelDescription: String? = nil,
         subscriptionDate: Date? = nil,
         channelProfileImageURL: String? = nil) {
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.channelDescription = channelDescription
        self.channelProfileImageURL = channelProfileImageURL
        self.subscriptionDate = subscriptionDate
    }
    
    init(subscriptionSnippet: GTLRYouTube_SubscriptionSnippet) {
        self.channelId = subscriptionSnippet.resourceId?.channelId
        self.channelTitle = subscriptionSnippet.title
        self.channelDescription = subscriptionSnippet.descriptionProperty
        self.channelProfileImageURL = subscriptionSnippet.thumbnails?.high?.url
        self.subscriptionDate = subscriptionSnippet.publishedAt?.date
    }
}
