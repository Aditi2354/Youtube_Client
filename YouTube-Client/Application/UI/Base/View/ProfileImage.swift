//
//  ProfileImage.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 21.05.2023.
//

import SwiftUI

struct ProfileImage: View {
    
    @State private var image: UIImage?
    
    let url: URL?
    let size: CGFloat
    
    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color(Resources.Colors.secondaryBackground))
            }
        }
        .frame(width: size, height: size)
        .task {
            if let url {
                image = try? await UIImageView.imageLoader.loadImage(from: url)
            }
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(url: URL(string: "https://yt3.googleusercontent.com/RZ5r4v_Yf2-dUPbPvLd18DcS3NOZcP1e72Wyeg_bfxev5tiBDYwniPw-oZqB8UThKu0heuct=s176-c-k-c0x00ffffff-no-rj"), size: 35)
    }
}
