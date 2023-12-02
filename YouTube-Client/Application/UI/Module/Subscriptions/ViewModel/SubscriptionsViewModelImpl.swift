//
//  SubscriptionsViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import Combine
import GoogleAPIClientForREST_YouTube

/// "Subscriptions" module flow coordinator implementation
final class SubscriptionsViewModelImpl: SubscriptionsViewModel {
    
    //MARK: Properties
    
    var dataLoadPublisher: AnyPublisher<Bool, Never> {
        $isLoading
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var subscriptionsVideosPublisher: AnyPublisher<[YouTubeVideoPreview], Never> {
        $subscriptionsVideos
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var subscriptionsChangePublisher: AnyPublisher<Void, Never> {
        $subscriptions
            .map { _ in }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        $error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    let fetchSubscriptionsSubject = PassthroughSubject<Void, Never>()
    
    @Published private var isLoading = false
    @Published private var subscriptionsVideos = [YouTubeVideoPreview]()
    @Published private var subscriptions = [YouTubeSubscription]()
    @Published private var error: Error?
    
    private let youTubeAPIService: YouTubeAPIService
    private let coordinator: SubscriptionsCoordinator
    
    private var subscriptionsLoadTask: Task<Void, Never>?
    private var nextSubscriptionListPageToken: String?
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initialization
    
    init(youTubeAPIService: YouTubeAPIService,
         coordinator: SubscriptionsCoordinator) {
        self.youTubeAPIService = youTubeAPIService
        self.coordinator = coordinator
        makeBindings()
    }
    
    //MARK: - Methods
    
    func viewModelForSubscriptionsMenuBar() -> SubscriptionsMenuBarViewModel {
        let menuDisplaySubscriptions = subscriptions.count < 30 ? subscriptions : Array(subscriptions[0..<30])
        return SubscriptionsMenuBarViewModelImpl(subscriptions: menuDisplaySubscriptions) { subscription in
            
        }
    }
    
    func viewModelForCell(with videoPreview: YouTubeVideoPreview) -> VideoPreviewCellViewModel {
        VideoPreviewCellViewModelImpl(videoPreview: videoPreview, youTubeAPIService: youTubeAPIService)
    }
    
    @MainActor
    func presentVideo(forIndexPath indexPath: IndexPath, channel: GTLRYouTube_Channel) {
        let videoPreview = subscriptionsVideos[indexPath.item]
        coordinator.runVideoViewingFlow(videoPreviewModel: videoPreview, channel: channel)
    }
}

//MARK: - Private methods

private extension SubscriptionsViewModelImpl {
    func makeBindings() {
        NotificationCenter.default.publisher(for: .GoogleUserSessionRestore)
            .map { _ in }
            .sink { [weak self] in
                self?.fetchSubscriptionsSubject.send()
            }
            .store(in: &cancellables)
        
        fetchSubscriptionsSubject
            .sink { [weak self] in
                guard let self else { return }
                self.subscriptionsLoadTask?.cancel()
                self.subscriptionsLoadTask = Task {
                    do {
                        try await self.fetchSubscriptions()
                    } catch {
                        self.isLoading = false
                        self.error = error
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchSubscriptions() async throws {
        isLoading = true

        let response = try await youTubeAPIService.getSubscriptions(maxResults: 30, nextPageToken: nil)
        nextSubscriptionListPageToken = response.nextPageToken
        
        let responseItems = response.items ?? []
        subscriptions = responseItems.compactMap {
            guard let snippet = $0.snippet else { return nil }
            return YouTubeSubscription(subscriptionSnippet: snippet)
        }

        let channelIDs = responseItems.compactMap(\.snippet?.resourceId?.channelId)
        let searchResults = try await getMostRecentVideosFromSubscriptions(for: channelIDs)
        let videosPreviews = searchResults.compactMap(YouTubeVideoPreview.init(searchResult:))
        subscriptionsVideos = videosPreviews
        
        isLoading = false
    }
    
    func createMostRecentVideoQuery(for channelId: String) -> GTLRYouTubeQuery_SearchList {
        let query = GTLRYouTubeQuery_SearchList.query(withPart: ["snippet"])
        query.type = ["video"]
        query.maxResults = 1
        query.channelId = channelId
        query.order = "date"
        return query
    }
    
    func getMostRecentVideosFromSubscriptions(for channelIDs: [String]) async throws -> [GTLRYouTube_SearchResult] {
        try await withThrowingTaskGroup(of: GTLRYouTube_SearchResult?.self) { [weak self] group in
            guard let self else { return [] }
            
            for id in channelIDs {
                let query = createMostRecentVideoQuery(for: id)
                group.addTask(priority: .utility) {
                    let response = try await self.youTubeAPIService.search(query: query)
                    return response.items?.first
                }
            }
            
            var searchResults = [GTLRYouTube_SearchResult]()
            
            for try await searchResult in group.compactMap({ $0 }) {
                searchResults.append(searchResult)
            }
            
            return searchResults
        }
    }
}
