//
//  SearchViewModelImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 01.07.2023.
//

import Combine
import GoogleAPIClientForREST_YouTube

final class SearchViewModelImpl: SearchViewModel {
    
    //MARK: Properties
    
    var searchResultsPublisher: AnyPublisher<[YouTubeVideoPreview], Never> {
        $searchResults
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
 
    @Published private var searchResults = [YouTubeVideoPreview]()
    
    private let youTubeAPIService: YouTubeAPIService
    private let coordinator: SearchCoordinator
    
    //MARK: - Initialization
    
    init(coordinator: SearchCoordinator, youTubeAPIService: YouTubeAPIService) {
        self.coordinator = coordinator
        self.youTubeAPIService = youTubeAPIService
    }
    
    //MARK: - Methods
    
    func search(searchQuery: String) async throws {
        let query = GTLRYouTubeQuery_SearchList.query(withPart: ["snippet"])
        query.q = searchQuery
        query.type = ["video"]
        query.maxResults = 50
        
        if #available(iOS 16, *) {
            query.regionCode = Locale.current.language.region?.identifier
        } else {
            query.regionCode = Locale.current.regionCode
        }
        
        let searchResponse = try await youTubeAPIService.search(query: query)
        let searchResponseItems = searchResponse.items ?? []
        
        searchResults = searchResponseItems.compactMap(YouTubeVideoPreview.init(searchResult:))
    }
    
    func viewModelForCell(with videoPreview: YouTubeVideoPreview) -> VideoPreviewCellViewModel {
        VideoPreviewCellViewModelImpl(videoPreview: videoPreview, youTubeAPIService: youTubeAPIService)
    }
    
    func presentVideo(forIndexPath indexPath: IndexPath, channel: GTLRYouTube_Channel) {
        let videoPreview = searchResults[indexPath.item]
        coordinator.runVideoViewingFlow(videoPreviewModel: videoPreview, channel: channel)
    }
    
    func perfomCoordinate(for action: SearchCoordinateAction) {
        coordinator.performCoordinate(for: action)
    }
}
