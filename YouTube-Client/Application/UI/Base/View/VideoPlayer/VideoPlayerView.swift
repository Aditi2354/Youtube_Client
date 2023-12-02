//
//  VideoPlayerView.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 20.05.2023.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    
    //MARK: Properties
    
    var player: AVPlayer?
    
    //MARK: - Methods
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
