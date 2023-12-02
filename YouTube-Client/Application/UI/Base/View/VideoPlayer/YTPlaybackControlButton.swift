//
//  YTPlaybackControlButton.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import SwiftUI

struct YTPlaybackControlButton: View {
    enum PlaybackControlType {
        case playPause
        case goForward
        case goBackward
    }
    
    //MARK: Properties
    
    let image: Image
    let controlType: PlaybackControlType
    let action: VoidClosure
    
    private var imageFont: Font {
        switch controlType {
        case .playPause:
            return .largeTitle
        case .goBackward, .goForward:
            return .title3
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        Button(action: action) {
            image
                .font(imageFont)
                .foregroundColor(.white)
                .padding()
                .background {
                    Circle()
                        .fill(.black.opacity(0.4))
                }
        }
    }
}

//MARK: - Preview

struct YTPlaybackControlButton_Previews: PreviewProvider {
    static var previews: some View {
        YTPlaybackControlButton(
            image: Image(systemName: "play.fill"),
            controlType: .playPause,
            action: {
                
            }
        )
    }
}
