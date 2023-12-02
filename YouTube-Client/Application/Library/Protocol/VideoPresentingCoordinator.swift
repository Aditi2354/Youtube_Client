//
//  VideoPresentingCoordinator.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 23.06.2023.
//

import GoogleAPIClientForREST_YouTube

protocol VideoPresentingCoordinator: Coordinator {
    var assemblyBuilder: AssemblyBuilder { get }
    var router: Router { get }
    func runVideoViewingFlow(videoPreviewModel: YouTubeVideoPreview, channel: GTLRYouTube_Channel)
}

extension VideoPresentingCoordinator {
    func runVideoViewingFlow(videoPreviewModel: YouTubeVideoPreview, channel: GTLRYouTube_Channel) {
        let module = assemblyBuilder.buildVideoViewingPageModule(
            videoPreviewModel: videoPreviewModel,
            channel: channel
        )
        router.present(module, animated: true, fullScreenDisplay: true)
    }
}
