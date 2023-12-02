//
//  VideoPresentingViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 23.06.2023.
//

import Foundation
import GoogleAPIClientForREST_YouTube

protocol VideoPresentingViewModel {
    func presentVideo(forIndexPath indexPath: IndexPath, channel: GTLRYouTube_Channel)
}
