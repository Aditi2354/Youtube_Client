//
//  HTTPError.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

import Foundation

/// Elimination of errors that may occur during the execution of HTTP requests
enum HTTPError: LocalizedError {
    case invalidURL
    case nonHTTPResponse
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case urlError(error: URLError)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Not possible to make a request to the specified address, since it is invalid"
        case .nonHTTPResponse:
            return "The request is not an HTTP request"
        case .clientError(let statusCode):
            return "The request failed with an error on the client side. Status code: \(statusCode)"
        case .serverError(let statusCode):
            return "The request failed with a server error. Status code: \(statusCode)"
        case .urlError(let error):
            return error.localizedDescription
        case .unknownError:
            return URLError(.unknown).localizedDescription
        }
    }
}
