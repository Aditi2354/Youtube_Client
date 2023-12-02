//
//  VideoCommentsBlock.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import SwiftUI

struct VideoCommentsBlock: View {
    let tapAction: VoidClosure
    let comments: [YouTubeComment]
    let allCommentsCount: Int
    
    var body: some View {
        Button(action: tapAction) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Comments")
                        .bold()
                    
                    Text(allCommentsCount.formatPositiveNumberToDisplay())
                        .foregroundStyle(.secondary)
                }
                .font(.callout)
                
                if let topComment = comments.first {
                    HStack(spacing: 10.0) {
                        ProfileImage(
                            url: URL(string: topComment.authorProfileImageURL ?? ""),
                            size: 25)
                        
                        Text(topComment.text ?? "")
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color(Resources.Colors.secondaryBackground))
            }
        }
    }
}

struct VideoCommentsBlock_Previews: PreviewProvider {
    static var previews: some View {
        VideoCommentsBlock(tapAction: {
            
        }, comments: Array(
            repeating: .init(
                authorChannelId: nil,
                authorChannelURL: nil,
                authorName: "Arctanyn",
                authorProfileImageURL: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj",
                likesCount: 216,
                text: "Great! Thank you",
                updatedAt: Date()
            ),
            count: 10
        ), allCommentsCount: 1560)
    }
}
