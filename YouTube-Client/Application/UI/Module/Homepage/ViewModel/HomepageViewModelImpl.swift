//
//  HomepageViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import Combine
import GoogleAPIClientForREST_YouTube

/// View Model implementation for the "Homepage" module
final class HomepageViewModelImpl: HomepageViewModel {

    //MARK: Properties
    
    var videosListPublisher: AnyPublisher<[YouTubeVideoPreview], Never> {
        $videos
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var dataLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        $error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    let videosCategorySubject = CurrentValueSubject<String?, Never>(nil)
    let retryLoadRecomendationsSubject = PassthroughSubject<Void, Never>()
    
    lazy var recomendedVideosCategories = makeRecomendedCategories()
    
    @Published private var videos = [YouTubeVideoPreview]()
    @Published private var isLoading = false
    @Published private var error: Error?
    
    private let youTubeAPIService: YouTubeAPIService
    private let coordinator: HomepageCoordinator
    
    private var recomendationsLoadTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initialization
    
    init(coordinator: HomepageCoordinator,
         youTubeAPIService: YouTubeAPIService) {
        self.coordinator = coordinator
        self.youTubeAPIService = youTubeAPIService
        makeBindings()
    }
    
    //MARK: - Methods

    func getRecomendations(for category: String) async throws {
        isLoading = true
        
        let query = makeSearchQuery(forCategory: category)
        let response = try await youTubeAPIService.search(query: query)
        let searchResultItems = response.items ?? []
        
        videos = searchResultItems.compactMap(YouTubeVideoPreview.init)
        isLoading = false
    }

    func viewModelForCell(with videoPreview: YouTubeVideoPreview) -> VideoPreviewCellViewModel {
        VideoPreviewCellViewModelImpl(videoPreview: videoPreview, youTubeAPIService: youTubeAPIService)
    }
    
    func presentVideo(forIndexPath indexPath: IndexPath, channel: GTLRYouTube_Channel) {
        let videoPreview = videos[indexPath.item]
        coordinator.runVideoViewingFlow(videoPreviewModel: videoPreview, channel: channel)
    }
}

//MARK: - Private methods

private extension HomepageViewModelImpl {
    func makeRecomendedCategories() -> [String] {
        [
            "Swift Language",
            "Lofi Music",
            "Programming",
            "iOS",
            "Apple",
            "Game Development",
            "Computer Science",
            "Anime Opening",
            "Japan Manga",
            "Podcasts",
            "Travel"
        ]
    }
    
    func makeSearchQuery(forCategory category: String) -> GTLRYouTubeQuery_SearchList  {
        let query = GTLRYouTubeQuery_SearchList.query(withPart: ["snippet"])
        query.q = category
        query.type = ["video"]
        query.maxResults = 50
        
        if #available(iOS 16, *) {
            query.regionCode = Locale.current.language.region?.identifier
        } else {
            query.regionCode = Locale.current.regionCode
        }
        
        return query
    }
    
    func makeBindings() {
        videosCategorySubject
            .compactMap { $0 }
            .sink { [weak self] category in
                guard let self else { return }
                self.recomendationsLoadTask?.cancel()
                self.recomendationsLoadTask = Task {
                    do {
                        try await self.getRecomendations(for: category)
                        self.error = nil
                    } catch {
                        self.isLoading = false
                        self.error = error
                    }
                }
            }
            .store(in: &cancellables)
        
        retryLoadRecomendationsSubject
            .sink { [weak self] in
                self?.videosCategorySubject.send(self?.videosCategorySubject.value)
            }
            .store(in: &cancellables)
    }
}
