//
//  YTVideoDoubleTapRewindArea.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 25.05.2023.
//

import SwiftUI

struct YTVideoDoubleTapRewindArea: View {
    
    enum Arrows: Int, CaseIterable {
        case first
        case second
        case third
    }
    
    //MARK: Properties
    
    @State private var isTapped = false
    @State private var showArrows: [Arrows: Bool] = [
        .first: false,
        .second: false,
        .third: false
    ]
    
    let isForward: Bool
    let doubleTapAction: VoidClosure
    
    //MARK: - Body
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .overlay {
                Circle()
                    .fill(.black.opacity(0.4))
                    .scaleEffect(2, anchor: isForward ? .leading : .trailing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            }
            .opacity(isTapped ? 1.0 : 0.0)
            .overlay {
                VStack(spacing: 15.0) {
                    HStack(spacing: 0.0) {
                        ForEach(Arrows.allCases.reversed(), id: \.self) { arrow in
                            Image (systemName: "arrowtriangle.backward.fill")
                                .font(.title2)
                                .opacity(showArrows[arrow] ?? false ? 1.0 : 0.2)
                        }
                    }
                    .rotationEffect(.degrees(isForward ? 180 : 0))
                    
                    Text("15 seconds")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .opacity(isTapped ? 1.0 : 0.0)
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 2) {
                animateArrows()
            }
    }
}

//MARK: - Private methods

private extension YTVideoDoubleTapRewindArea {
    func animateArrows() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isTapped = true
            showArrows[.first] = true
        }
        
        withAnimation(.easeInOut(duration: 0.2).delay(0.2)) {
            showArrows[.first] = false
            showArrows[.second] = true
        }
        
        withAnimation(.easeInOut(duration: 0.2).delay(0.4)) {
            showArrows[.second] = false
            showArrows[.third] = true
        }
        
        withAnimation(.easeInOut(duration: 0.2).delay(0.5)) {
            showArrows[.third] = false
            isTapped = false
        }
        
        doubleTapAction()
    }
}

//MARK: - Preview

struct YTVideoDoubleTapRewindArea_Previews: PreviewProvider {
    static var previews: some View {
        VideoViewingPage<VideoViewingPage_Previews.PreviewViewModel>(viewModel: VideoViewingPage_Previews.viewModel)
    }
}
