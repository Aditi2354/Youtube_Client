//
//  VideoViewingPage_Previews + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 20.05.2023.
//

import SwiftUI
import GoogleAPIClientForREST_YouTube

extension VideoViewingPage_Previews {
    static let viewModel = PreviewViewModel()
    
    final class PreviewViewModel: VideoViewingPageViewModel {
        @Published var isInfoLoaded: Bool = false
        
        var videoTitle: String {
            videoPreview.title ?? ""
        }
        
        var thumbnailImageURL: URL? {
            guard let urlString = videoPreview.thumbnailURL else {
                return nil
            }
            return URL(string: urlString)
        }
        
        var viewsCount: String {
            return 185_430.formatPositiveNumberToDisplay() + " views"
        }
        
        var likesCount: String {
            return 16_865.formatPositiveNumberToDisplay()
        }
        
        var commentsCount: Int {
            return comments.count
        }
        
        var channelSubscribersCount: String {
            return 25_689.formatPositiveNumberToDisplay()
        }
        
        var publishedAt: String {
            return "5h ago"
        }
        
        var channelTitle: String {
            videoPreview.channel?.title ?? ""
        }
        
        var channelProfileThumbnailURL: URL? {
            return URL(string: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj")
        }
        
        var comments: [YouTubeComment] = []
        
        private let videoPreview = YouTubeVideoPreview(
            id: "qi6qh89a1",
            channel: .init(id: "pnc7b12ja", title: "Arctanyn"),
            title: "iOS Development Crash Course | Swift Tutorial | View Controller",
            publishedAt: Date(),
            thumbnailURL: "https://devimages-cdn.apple.com/wwdc-services/articles/images/9016B61B-3E8D-4153-BEAD-27021EEFEC16/2048.jpeg"
        )
        
        func fetchInfo() async throws {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            await MainActor.run {
                comments = [
                    .init(
                        authorChannelId: nil,
                        authorChannelURL: nil,
                        authorName: "Arctanyn",
                        authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
                        likesCount: 80,
                        text: "Cool 😎",
                        updatedAt: Date()
                    ),
                    .init(
                        authorChannelId: nil,
                        authorChannelURL: nil,
                        authorName: "Arctanyn",
                        authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
                        likesCount: 1,
                        text: "👍🏻",
                        updatedAt: Date()
                    ),
                    .init(
                        authorChannelId: nil,
                        authorChannelURL: nil,
                        authorName: "Arctanyn",
                        authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
                        likesCount: 216,
                        text: "Great! Thank you",
                        updatedAt: Date()
                    ),
                    .init(
                        authorChannelId: nil,
                        authorChannelURL: nil,
                        authorName: "Arctanyn",
                        authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
                        likesCount: 20,
                        text: "Very interesting",
                        updatedAt: Date()
                    ),
                ]
                
                isInfoLoaded = true
            }
        }
    }
}
