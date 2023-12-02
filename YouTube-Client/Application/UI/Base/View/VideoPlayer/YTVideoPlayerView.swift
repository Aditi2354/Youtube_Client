//
//  YTVideoPlayerView.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 21.05.2023.
//

import SwiftUI
import AVKit
import AVFoundation

struct YTVideoPlayerView: View {
    
    enum DoubleTapRewindDirection {
        case forward
        case backward
    }
    
    //MARK: Properties
    
    @GestureState private var isDragging = false
    
    @Binding var isRotated: Bool
    let dismissAction: VoidClosure
    
    @State private var currentPlayer: AVPlayer?
    @State private var previousPlayer: AVPlayer?
    @State private var nextPlayer: AVPlayer?
    
    @State private var isShowPlaybackControls = false
    @State private var isPlaying = true
    
    @State private var playbackControlsTimeoutWorkItem: DispatchWorkItem?
    
    @State private var videoProgress: CGFloat = 0
    @State private var lastDragProgress: CGFloat = 0
    
    @State private var isVideoFinished = false
    
    @State private var isAddedPlayerObserver = false
    
    @State private var thumbnailFrames = [UIImage]()
    @State private var draggingImagePreview: UIImage?
    
    @State private var playerStatusObserver: NSKeyValueObservation?
    
    //MARK: - Initialization
    
    init(url: URL, isRotated: Binding<Bool>, dismissAction: @escaping VoidClosure) {
        currentPlayer = AVPlayer(url: url)
        self._isRotated = isRotated
        self.dismissAction = dismissAction
    }
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            let videoPlayerSize = proxy.size
            
            VStack {
                if let currentPlayer {
                    VideoPlayerView(player: currentPlayer)
                        .frame(
                            width: videoPlayerSize.width,
                            height: videoPlayerSize.height
                        )
                        .overlay {
                            Rectangle()
                                .fill(.black.opacity(0.6))
                                .opacity(isShowPlaybackControls || isDragging ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.2), value: isDragging)
                            
                            PlaybackControls()
                        }
                        .overlay {
                            HStack {
                                YTVideoDoubleTapRewindArea(isForward: false) {
                                    seekPlayerByDoubleTap(to: .backward)
                                }
                                
                                YTVideoDoubleTapRewindArea(isForward: true) {
                                    seekPlayerByDoubleTap(to: .forward)
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isShowPlaybackControls.toggle()
                            }
                            
                            if isPlaying {
                                timeoutControls()
                            }
                        }
                        .overlay(alignment: .top) {
                            if isShowPlaybackControls {
                                TopMenuPanel()
                            }
                        }
                        .overlay(alignment: .leading) {
                            SeekingThumbnailView(videoPlayerSize: videoPlayerSize)
                        }
                        .overlay(alignment: .bottom) {
                            BottomMenuPanel(videoPlayerSize: videoPlayerSize)
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                addPlayerTimeObserver()
                
                playerStatusObserver = currentPlayer?.observe(\.status, options: [.old, .new]) { player, _ in
                    if player.status == .readyToPlay, thumbnailFrames.isEmpty {
                        generateThumbnailFrames()
                    }
                }
                
                currentPlayer?.play()
            }
            .onChange(of: isVideoFinished) { isFinished in
                if isFinished {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isShowPlaybackControls = true
                    }
                }
            }
            .onDisappear {
                playerStatusObserver?.invalidate()
                currentPlayer?.pause()
                currentPlayer = nil
            }
        }
    }
}

//MARK: - Local Views

private extension YTVideoPlayerView {
    @ViewBuilder
    func TopMenuPanel() -> some View {
        HStack {
            Button {
                dismissAction()
            } label: {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .font(.title3)
                    .frame(width: 25, height: 25)
                    .contentShape(Rectangle())
                    .frame(width: 50, height: 50)
                    .frame(width: 25, height: 25)
            }
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func BottomMenuPanel(videoPlayerSize: CGSize) -> some View {
        VStack {
            HStack(spacing: 40.0) {
                HStack(spacing: 5.0) {
                    Text(currentPlayerItem?.currentTime().convertToTimeString() ?? "0:00")
                    Group {
                        Text("/")
                        Text(CMTime(seconds: currentPlayerItem?.duration.seconds ?? 0, preferredTimescale: 600).convertToTimeString())
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isRotated.toggle()
                    }
                } label: {
                    Image(systemName: isRotated ? "arrow.down.forward.and.arrow.up.backward" : "arrow.up.left.and.arrow.down.right")
                        .font(.title3)
                        .frame(width: 25, height: 25)
                        .contentShape(Rectangle())
                        .frame(width: 50, height: 50)
                        .frame(width: 25, height: 25)
                }
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .padding(.bottom, 25)
            .opacity(isShowPlaybackControls && !isDragging ? 1.0 : 0.0)
            
            VideoSeekerView(videoPlayerSize: videoPlayerSize)
                .padding(.horizontal, isRotated ? 10 : 0)
                .opacity(isRotated ? (isShowPlaybackControls ? 1.0 : 0.0) : 1.0)
        }
        .padding(.bottom, isRotated ? 30 : 0)
    }
    
    
    @ViewBuilder
    func PlaybackControls() -> some View {
        HStack(spacing: 40.0) {
            YTPlaybackControlButton(
                image: Image(systemName: "backward.end.fill"),
                controlType: .goBackward) {
                    
                }
                .opacity(previousPlayer == nil ? 0.65 : 1.0)
                .disabled(previousPlayer == nil)
            
            YTPlaybackControlButton(
                image: Image(systemName: isVideoFinished ? "arrow.counterclockwise" : isPlaying ? "pause.fill" : "play.fill"),
                controlType: .playPause,
                action: {
                    if isVideoFinished {
                        isVideoFinished = false
                        seekPlayer(to: .zero)
                        videoProgress = 0
                        lastDragProgress = 0
                    }
                    
                    if isPlaying {
                        currentPlayer?.pause()
                        playbackControlsTimeoutWorkItem?.cancel()
                    } else {
                        currentPlayer?.play()
                        timeoutControls()
                    }
                    
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPlaying.toggle()
                    }
                })
            
            YTPlaybackControlButton(
                image: Image(systemName: "forward.end.fill"),
                controlType: .goForward) {
                    
                }
                .opacity(previousPlayer == nil ? 0.65 : 1.0)
                .disabled(nextPlayer == nil)
            
        }
        .foregroundColor(.white)
        .opacity(isShowPlaybackControls && !isDragging ? 1.0 : 0.0)
        .animation(
            .easeIn(duration: 0.2),
            value: isShowPlaybackControls && !isDragging
        )
    }
    
    @ViewBuilder
    func SeekingThumbnailView(videoPlayerSize: CGSize) -> some View {
        let thumbnailSize = CGSize(
            width: videoPlayerSize.width * (isRotated ? 0.3 : 0.45),
            height: videoPlayerSize.height * (isRotated ? 0.3 : 0.45)
        )
        
        let thumbnailCornerRadius: CGFloat = 10
        
        VStack {
            if let draggingImagePreview, isDragging {
                Image(uiImage: draggingImagePreview)
                    .resizable()
                    .scaledToFill()
                    .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: thumbnailCornerRadius, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: thumbnailCornerRadius, style: .continuous)
                            .stroke(.white, lineWidth: 1.5)
                    }
            } else {
                RoundedRectangle(cornerRadius: thumbnailCornerRadius, style: .continuous)
                    .fill(.black)
                    .overlay {
                        RoundedRectangle(cornerRadius: thumbnailCornerRadius, style: .continuous)
                            .stroke(.white, lineWidth: 1.5)
                    }
            }
            
            if let currentItem = currentPlayer?.currentItem {
                let time = CMTime(seconds: videoProgress * currentItem.duration.seconds, preferredTimescale: 600)
                
                Text(time.convertToTimeString())
                    .foregroundColor(.white)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .offset(y: 15)
            }
        }
        .opacity(isDragging ? 1.0 : 0.0)
        .offset(x: videoProgress * (videoPlayerSize.width - thumbnailSize.width - 20))
        .offset(x: 10)
    }
    
    @ViewBuilder
    func VideoSeekerView(videoPlayerSize: CGSize) -> some View {
        let progressLineWidth = videoProgress * videoPlayerSize.width
        let checkedLineWidth = progressLineWidth.isFinite ? progressLineWidth : .zero
 
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
            
            Rectangle()
                .fill(Color(Resources.Colors.red))
                .frame(
                    minWidth: 0,
                    idealWidth: checkedLineWidth,
                    maxWidth: checkedLineWidth
                )
        }
        .frame(height: 2.5)
        .overlay(alignment: .leading) {
            Circle()
                .fill(Color(Resources.Colors.red))
                .frame(width: 15, height: 15)
                .scaleEffect(isShowPlaybackControls || isDragging ? 1.0 : 0.001, anchor: videoProgress * videoPlayerSize.width > 15 ? .trailing : .leading)
                .frame(width: 50, height: 50)
                .contentShape(Rectangle())
                .offset(x: videoPlayerSize.width * videoProgress)
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { _, state, _ in
                            state = true
                        })
                        .onChanged { value in
                            if let playbackControlsTimeoutWorkItem {
                                playbackControlsTimeoutWorkItem.cancel()
                            }
                            
                            let translationX = value.translation.width
                            let newProgress = (translationX / videoPlayerSize.width) + lastDragProgress
                            
                            videoProgress = max(min(newProgress, 1), 0)
                            
                            let dragIndex = Int(videoProgress / 0.01)
                            
                            if thumbnailFrames.indices.contains(dragIndex) {
                                draggingImagePreview = thumbnailFrames[dragIndex]
                            }
                        }
                        .onEnded { value in
                            lastDragProgress = videoProgress
                            
                            if let currentPlayerItem {
                                let duration = currentPlayerItem.duration.seconds
                                
                                seekPlayer(to: CMTime(seconds: duration * videoProgress, preferredTimescale: 600))
                            }
                            
                            if isVideoFinished {
                                isVideoFinished = false
                                isPlaying = true
                                currentPlayer?.play()
                            }
                            
                            if isPlaying {
                                timeoutControls()
                            }
                        }
                )
                .offset(x: videoPlayerSize.width * videoProgress > 15 ? -15 : 0)
                .frame(width: 15, height: 15)
        }
    }
}

//MARK: - Private methods

private extension YTVideoPlayerView {
    var currentPlayerItem: AVPlayerItem? {
        currentPlayer?.currentItem
    }
    
    func addPlayerTimeObserver() {
        guard !isAddedPlayerObserver else { return }
        currentPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main, using: { time in
            if let currentPlayerItem {
                let duration = currentPlayerItem.duration.seconds
                
                let currentPlayerTime = currentPlayerItem.currentTime().seconds
                
                let progress = currentPlayerTime / duration
                
                if !isDragging {
                    videoProgress = progress
                    lastDragProgress = videoProgress
                }
                
                if videoProgress == 1 {
                    isVideoFinished = true
                    isPlaying = false
                }
            }
        })
        
        isAddedPlayerObserver = true
    }
    
    func timeoutControls() {
        if let playbackControlsTimeoutWorkItem {
            playbackControlsTimeoutWorkItem.cancel()
        }
        
        playbackControlsTimeoutWorkItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.2)) {
                isShowPlaybackControls = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: playbackControlsTimeoutWorkItem!)
    }
    
    func seekPlayer(to time: CMTime) {
        currentPlayer?.seek(to: time)
    }
    
    func seekPlayerByDoubleTap(to direction: DoubleTapRewindDirection) {
        guard let currentPlayer else { return }
        let currentSeconds = currentPlayer.currentTime().seconds
        let newSeconds = currentSeconds + (direction == .forward ? 15 : -15)
        videoProgress = newSeconds
        
        if isVideoFinished, direction == .backward {
            isVideoFinished = false
        } else if currentSeconds >= currentPlayer.currentItem?.duration.seconds ?? 0 {
            isVideoFinished = true
        }
        
        seekPlayer(to: CMTime(seconds: newSeconds, preferredTimescale: 600))
    }
    
    func generateThumbnailFrames() {
        Task {
            guard let asset = currentPlayer?.currentItem?.asset else { return }
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.maximumSize = CGSize(width: 250, height: 250)
            imageGenerator.appliesPreferredTrackTransform = false
            
            do {
                let duration = try await asset.load(.duration).seconds
                var frameTimes = [CMTime]()
                
                for progress in stride(from: 0, to: 1, by: 0.01) {
                    let time = CMTime(seconds: progress * duration, preferredTimescale: 600)
                    frameTimes.append(time)
                }
                
                for await image in imageGenerator.images(for: frameTimes) {
                    let cgImage = try image.image
                    await MainActor.run {
                        thumbnailFrames.append(UIImage(cgImage: cgImage))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - Preview

struct YTVideoPlayerView_Preview: PreviewProvider {
    static var previews: some View {
        VideoViewingPage<VideoViewingPage_Previews.PreviewViewModel>(viewModel: VideoViewingPage_Previews.viewModel)
    }
}
