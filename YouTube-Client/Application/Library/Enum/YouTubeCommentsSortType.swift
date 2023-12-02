//
//  YouTubeCommentsSortType.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import Foundation

enum YouTubeCommentsSortType: Identifiable, CaseIterable {
    case mostPopular
    case mostRecent
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .mostPopular:
            return "Top"
        case .mostRecent:
            return "Newest"
        }
    }
}
