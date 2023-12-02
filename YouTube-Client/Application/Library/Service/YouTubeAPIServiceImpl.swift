//
//  YouTubeAPIServiceImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 08.05.2023.
//

import GoogleSignIn
import GoogleAPIClientForREST_YouTube
import Combine

/// Implementation of the service for working with the YouTube API
struct YouTubeAPIServiceImpl: YouTubeAPIService {
    
    //MARK: Properties
    
    private let service: GTLRYouTubeService
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initialization
    
    init(service: GTLRYouTubeService = GTLRYouTubeService()) {
        self.service = service
        service.apiKey = getAPIKey()
        makeBindings()
    }
    
    //MARK: - Methods
    
    func search(query: GTLRYouTubeQuery_SearchList) async throws -> GTLRYouTube_SearchListResponse {
        try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { serviceTicket, response, error in
                if let error {
                    continuation.resume(throwing: YouTubeAPIError.requestProcessingError(error))
                    return
                }
                
                do {
                    let searchResponse = try getSpecificResponse(
                        type: GTLRYouTube_SearchListResponse.self,
                        from: response
                    )
                    continuation.resume(returning: searchResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getVideo(id: String) async throws -> GTLRYouTube_Video? {
        let query = GTLRYouTubeQuery_VideosList.query(withPart: ["snippet", "contentDetails", "statistics"])
        query.identifier = [id]
        
        let videosList = try await getVideosList(query: query)
        return videosList.first
    }
    
    func getVideosList(query: GTLRYouTubeQuery_VideosList) async throws -> [GTLRYouTube_Video] {
        try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { serviceTicket, response, error in
                if let error {
                    continuation.resume(throwing: YouTubeAPIError.requestProcessingError(error))
                    return
                }

                do {
                    let videosListResponse = try getSpecificResponse(
                        type: GTLRYouTube_VideoListResponse.self,
                        from: response
                    )
                    continuation.resume(returning: videosListResponse.items ?? [])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getChannel(id: String) async throws -> GTLRYouTube_Channel? {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: ["snippet", "contentDetails", "statistics"])
        query.identifier = [id]
        
        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { serviceTicket, response, error in
                if let error {
                    continuation.resume(throwing: YouTubeAPIError.requestProcessingError(error))
                    return
                }
                
                do {
                    let channelsResult = try getSpecificResponse(
                        type: GTLRYouTube_ChannelListResponse.self,
                        from: response
                    )
                    continuation.resume(returning: channelsResult.items?.first)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getComments(videoId: String) async throws -> [GTLRYouTube_CommentThread] {
        let query = GTLRYouTubeQuery_CommentThreadsList.query(withPart: ["snippet"])
        query.videoId = videoId
        query.maxResults = 100
        
        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { serviceTicket, response, error in
                if let error {
                    continuation.resume(throwing: YouTubeAPIError.requestProcessingError(error))
                    return
                }
                
                do {
                    let commentsThreadListResponse = try getSpecificResponse(
                        type: GTLRYouTube_CommentThreadListResponse.self,
                        from: response
                    )
                    continuation.resume(returning: commentsThreadListResponse.items ?? [])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getSubscriptions(maxResults: Int = 5, nextPageToken: String? = nil) async throws -> GTLRYouTube_SubscriptionListResponse {
        guard service.authorizer != nil else {
            throw YouTubeAPIError.unauthorizedRequest
        }
        
        let query = GTLRYouTubeQuery_SubscriptionsList.query(withPart: ["snippet", "contentDetails"])
        query.maxResults = UInt(maxResults)
        query.mine = true
                
        return try await withCheckedThrowingContinuation { continuation in
            service.executeQuery(query) { serviceTicket, response, error in
                if let error {
                    continuation.resume(throwing: YouTubeAPIError.requestProcessingError(error))
                    return
                }
                
                do {
                    let subscriptionListResponse = try getSpecificResponse(
                        type: GTLRYouTube_SubscriptionListResponse.self,
                        from: response
                    )
                    continuation.resume(returning: subscriptionListResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

//MARK: - Private methods

private extension YouTubeAPIServiceImpl {
    func setServiceAuthorizer() async {
        guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
            service.authorizer = try? await GIDSignIn.sharedInstance.restorePreviousSignIn().fetcherAuthorizer
            return
        }
        service.authorizer = currentUser.fetcherAuthorizer
    }
    
    mutating func makeBindings() {
        NotificationCenter.default.publisher(for: .GoogleUserSessionRestore)
            .compactMap { $0.object as? GIDGoogleUser }
            .sink { [weak service] user in
                service?.authorizer = user.fetcherAuthorizer
            }
            .store(in: &cancellables)
    }
    
    func getSpecificResponse<T>(type: T.Type, from response: Any?) throws -> T {
        guard let myResponse = response as? T else {
            throw YouTubeAPIError.invalidResponse
        }
        return myResponse
    }
    
    func getAPIKey() -> String? {
        let infoDictionary = Bundle.main.infoDictionary
        return infoDictionary?["API_KEY"] as? String
    }
}
