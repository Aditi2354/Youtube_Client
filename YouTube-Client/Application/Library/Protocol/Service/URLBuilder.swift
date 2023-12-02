//
//  URLBuilder.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

import Foundation

/// A protocol that provides an interface for building a URL
protocol URLBuilder {
    
    /// Builds a URL from the transmitted components of the desired address
    ///
    /// Use to build a properly designed full URL using its individual components
    ///
    /// ```swift
    /// let urlBuilder: URLBuilder
    ///
    /// let urlScheme = "https"
    /// let urlHost = "www.google.com"
    /// let urlQuery = ["client": "safari"]
    ///
    /// let url = urlBuilder.buildURL(scheme: urlScheme, host: urlHost, path: nil,  queryParameters: urlQuery)
    /// //Returns: https://www.google.com/?client=safari
    /// ```
    ///
    /// - Parameters:
    ///   - scheme: URL scheme
    ///   - host: URL host adress (domain name)
    ///   - path: URL path (end point)
    ///   - queryParameters: URL query parameters (query strings)
    /// - Returns: URL constructed from the specified components
    func buildURL(scheme: String, host: String, path: String?, queryParameters: [String: Any]?) -> URL?
}
