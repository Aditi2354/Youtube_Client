//
//  YTCommentRow.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import SwiftUI

struct YTCommentRow: View {
    let comment: YouTubeComment
    
    var body: some View {
        HStack(alignment: .top, spacing: 15.0) {
            ProfileImage(url: URL(string: comment.authorProfileImageURL ?? ""), size: 25)
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text("\(comment.authorName ?? "") • \(comment.updatedAt?.passedTimeRelativeToNowString ?? "")")
                    .foregroundColor(Color(Resources.Colors.secondaryText))
                Text(comment.text ?? "")
                    .multilineTextAlignment(.leading)
                
                ActionButtons()
                    .padding(.top)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .tint(.primary)
            
        }
        .font(.callout)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//MARK: - Local Views

private extension YTCommentRow {
    @ViewBuilder
    func ActionButtons() -> some View {
        HStack(spacing: 50.0) {
            HStack(spacing: 5.0) {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text(comment.likesCount?.formatPositiveNumberToDisplay() ?? "")
                    }
                }
                .frame(width: 70, alignment: .leading)

                Button {
                    
                } label: {
                    Image(systemName: "hand.thumbsdown")
                }
            }
            
            Button {
                
            } label: {
                Image(systemName: "text.bubble")
            }

        }
    }
}

struct YTCommentRow_Previews: PreviewProvider {
    static var previews: some View {
        YTCommentRow(comment: .init(
            authorChannelId: nil,
            authorChannelURL: nil,
            authorName: "Arctanyn",
            authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
            likesCount: 216,
            text: "Great! Thank you",
            updatedAt: Date()
        ))
    }
}
