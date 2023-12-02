//
//  SearchViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 01.07.2023.
//

import Combine

protocol SearchViewModel: AnyObject, VideoPresentingViewModel {
    var searchResultsPublisher: AnyPublisher<[YouTubeVideoPreview], Never> { get }
    func search(searchQuery: String) async throws
    func viewModelForCell(with videoPreview: YouTubeVideoPreview) -> VideoPreviewCellViewModel
    func perfomCoordinate(for action: SearchCoordinateAction)
}
