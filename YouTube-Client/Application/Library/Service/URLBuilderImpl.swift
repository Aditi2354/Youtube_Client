//
//  URLBuilderImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

import Foundation

struct URLBuilderImpl: URLBuilder {
    func buildURL(scheme: String,
                  host: String,
                  path: String?,
                  queryParameters: [String : Any]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path ?? "/"
        
        if let queryParameters {
            urlComponents.queryItems = makeURLQueryItems(from: queryParameters)
        }

        return urlComponents.url
    }
}

//MARK: - Private methods

private extension URLBuilderImpl {
    func makeURLQueryItems(from queryParameters: [String: Any]) -> [URLQueryItem] {
        queryParameters.map { URLQueryItem(name: $0, value: "\($1)") }
    }
}
