//
//  VideoViewingPage.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 20.05.2023.
//

import SwiftUI
import AVKit

struct VideoViewingPage<ViewModel: VideoViewingPageViewModel>: View {
    
    //MARK: Properties
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var viewModel: ViewModel
    
    @State private var isRotated = false
    @State private var isShowComments = false
    @State private var commentsSortType = YouTubeCommentsSortType.mostPopular
    
    //MARK: - Initialization
    
    init(viewModel: some VideoViewingPageViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel as! ViewModel)
    }
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeAreaInsets = proxy.safeAreaInsets
            
            let videoPlayerSize = CGSize(
                width: isRotated ? size.height : size.width,
                height: isRotated ? size.width : (size.width * 9.0 / 16.0)
            )
            
            ZStack {
                if isRotated {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                        .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                }
                
                VStack(spacing: 15.0) {
                    ZStack {
                        if let url = Bundle.main.url(forResource: "VideoExample", withExtension: "mp4") {
                            YTVideoPlayerView(
                                url: url,
                                isRotated: $isRotated,
                                dismissAction: dismiss.callAsFunction
                            )
                        } else {
                            Rectangle()
                                .fill(.black)
                        }
                    }
                    .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
                    .background {
                        Rectangle()
                            .fill(.black)
                            .padding(.trailing, isRotated ? -safeAreaInsets.bottom : 0)
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if -value.translation.height > 100 {
                                        isRotated = true
                                    } else {
                                        isRotated = false
                                    }
                                }
                            }
                    )
                    .frame(width: size.width, height: size.width * 9.0 / 16.0, alignment: .bottomLeading)
                    .offset(y: isRotated ? -((size.width / 2) + safeAreaInsets.bottom + (safeAreaInsets.bottom > 0 ? 0 : 20)) : 0)
                    .rotationEffect(isRotated ? .degrees(90) : .zero, anchor: .topLeading)
                    .zIndex(1000)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15.0) {
                            VideoBaseInfoButton()
                            ChannelInfoView()
                            
                            if viewModel.isInfoLoaded {
                                Group {
                                    ActionButtons()
                                    VideoCommentsBlock(tapAction: {
                                        isShowComments.toggle()
                                    }, comments: viewModel.comments, allCommentsCount: viewModel.commentsCount)
                                }
                                .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                            } else {
                                Group {
                                    ActionButtons()
                                        .redacted(reason: .placeholder)
                                    RedachedVideoCommentsBlock()
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    
                    Spacer()
                }
                .onChange(of: isRotated, perform: { newValue in
                    if newValue, isShowComments {
                        isShowComments = false
                    }
                })
                .sheet(isPresented: $isShowComments) {
                    let sheetHeight = size.height - videoPlayerSize.height - 8
                    
                    VideoCommentsList(
                        comments: viewModel.comments,
                        isShowComments: $isShowComments,
                        sortType: $commentsSortType
                    )
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(sheetHeight), .large])
                    .presentationContentInteraction(.scrolls)
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(sheetHeight)))
                }
                
                .statusBarHidden(false)
                .toolbarColorScheme(
                    colorScheme == .dark ? .light : .dark,
                    for: .navigationBar
                )
                .task{
                    try? await viewModel.fetchInfo()
                }
            }
            .statusBarHidden(isRotated)
        }
    }
}

//MARK: - Local Views

private extension VideoViewingPage {
    @ViewBuilder
    func ActionButtons() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10.0) {
                RateButtons()
                
                VideoPageActionButton {
                    
                } content: {
                    Image(systemName: "arrowshape.turn.up.left")
                        .rotationEffect(.degrees(180))
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 1, y: 0, z: 0)
                        )
                    Text("Share")
                        .fontWeight(.semibold)
                }
                
                VideoPageActionButton {
                    
                } content: {
                    Image(systemName: "plus.square.on.square")
                        .rotationEffect(.degrees(180))
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    Text("Save")
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func RateButtons() -> some View {
        HStack(spacing: 15.0) {
            Button {
                
            } label: {
                HStack(spacing: 10.0) {
                    Image(systemName: "hand.thumbsup")
                    Text(viewModel.likesCount)
                        .fontWeight(.semibold)
                }
            }
            .padding(.leading, 5)
            
            Divider()
            
            Button {
                
            } label: {
                Image(systemName: "hand.thumbsdown")
            }
            .padding(.trailing, 5)
        }
        .font(.system(size: 15))
        .tint(.primary)
        .padding(10)
        .background {
            Capsule(style: .continuous)
                .fill(Color(Resources.Colors.secondaryBackground))
        }
    }
    
    @ViewBuilder
    func VideoBaseInfoButton() -> some View {
        Button {
            
        } label: {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(viewModel.videoTitle)
                    .foregroundColor(.primary)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if viewModel.isInfoLoaded {
                    VideoStatisticsView()
                } else {
                    VideoStatisticsView()
                        .redacted(reason: .placeholder)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .disabled(!viewModel.isInfoLoaded)
    }
    
    @ViewBuilder
    func VideoStatisticsView() -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 10.0) {
            Text(viewModel.viewsCount)
            Text(viewModel.publishedAt)
            
            Text("...more")
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .foregroundColor(Color(Resources.Colors.secondaryText))
        .font(.subheadline)
    }
    
    @ViewBuilder
    func ChannelInfoView() -> some View {
        HStack {
            Button {
                
            } label: {
                HStack(alignment: .center, spacing: 10.0) {
                    ProfileImage(
                        url: viewModel.channelProfileThumbnailURL,
                        size: 35
                    )
                    
                    HStack(alignment: .lastTextBaseline, spacing: 10.0) {
                        Text(viewModel.channelTitle)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Text(viewModel.channelSubscribersCount)
                            .font(.subheadline)
                            .foregroundColor(Color(Resources.Colors.secondaryText))
                    }
                }
            }
            .foregroundColor(.primary)
            
            Spacer()
            
            SubscribeButton()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func SubscribeButton() -> some View {
        Button {
            
        } label: {
            Text("Subscribe")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemBackground))
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    Capsule(style: .continuous)
                        .foregroundColor(.primary)
                )
                .onTapGesture {
                    print(#function)
                }
        }
    }
}

//MARK: - Preview

struct VideoViewingPage_Previews: PreviewProvider {
    static var previews: some View {
        VideoViewingPage<Self.PreviewViewModel>(viewModel: Self.viewModel)
    }
}
