//
//  VideoCommentsList.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import SwiftUI

struct VideoCommentsList: View {
 
    //MARK: Properties
    
    let comments: [YouTubeComment]
    @Binding var isShowComments: Bool
    
    @Binding var sortType: YouTubeCommentsSortType
    
    //MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Comments")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        isShowComments.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.medium)
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                }
                
                HStack {
                    ForEach(YouTubeCommentsSortType.allCases) { type in
                        CommentsSortTypeButton(type)
                    }
                }
            }
            .padding([.top, .horizontal])
            
            Divider()
            
            List {
                ForEach(getSortedComments(by: sortType)) { comment in
                    YTCommentRow(comment: comment)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .padding(.top)
    }
}

//MARK: - Local Views

private extension VideoCommentsList {
    @ViewBuilder
    func CommentsSortTypeButton(_ type: YouTubeCommentsSortType) -> some View {
        Button {
            sortType = type
        } label: {
            Text(type.title)
                .foregroundColor(sortType == type ? Color(.systemBackground) : .primary)
                .fontWeight(.semibold)
                .padding(10)
                .padding(.horizontal, 5)
                .background {
                    Capsule()
                        .fill(sortType == type ? .primary : Color(Resources.Colors.secondaryBackground))
                }
        }
    }
}

//MARK: - Private methods

private extension VideoCommentsList {
    func getSortedComments(by type: YouTubeCommentsSortType) -> [YouTubeComment] {
        comments.sorted {
            switch type {
            case .mostPopular:
                return $0.likesCount ?? 0 > $1.likesCount ?? 0
            case .mostRecent:
                return $0.updatedAt ?? Date() > $1.updatedAt ?? Date()
            }
        }
    }
}

//MARK: - Preview

struct VideoCommentsList_Previews: PreviewProvider {
    static var previews: some View {
        VideoCommentsList(comments: [
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
                likesCount: 80,
                text: "Cool 😎",
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
            .init(
                authorChannelId: nil,
                authorChannelURL: nil,
                authorName: "Arctanyn",
                authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
                likesCount: 1,
                text: "👍🏻",
                updatedAt: Date()
            ),
        ], isShowComments: .constant(true), sortType: .constant(.mostPopular))
    }
}
