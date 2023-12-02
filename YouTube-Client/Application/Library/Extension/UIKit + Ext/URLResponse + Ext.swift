//
//  URLResponse + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 05.05.2023.
//

import Foundation

extension URLResponse {
    
    /// Processes the network URL response and throws an error if it does not meet the basic checks
    ///
    /// Use it to process the response received during a network request to check it for errors
    ///
    /// - Throws: HTTPError instance
    func handle() throws {
        guard let httpResponse = self as? HTTPURLResponse else {
            throw HTTPError.nonHTTPResponse
        }
        
        let statusCode = httpResponse.statusCode
        
        switch statusCode {
        case 200..<300:
            return
        case 400..<500:
            throw HTTPError.clientError(statusCode: statusCode)
        case 500..<600:
            throw HTTPError.serverError(statusCode: statusCode)
        default:
            throw HTTPError.unknownError
        }
    }
}
