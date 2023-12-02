//
//  YouTubeAPIError.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 08.05.2023.
//

import Foundation

enum YouTubeAPIError: LocalizedError {
    case invalidResponse
    case requestProcessingError(Error)
    case unauthorizedRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response received"
        case .requestProcessingError(let error):
            return "Request execution error: \(error.localizedDescription)"
        case .unauthorizedRequest:
            return "The request used requires authorization parameters"
        }
    }
}
