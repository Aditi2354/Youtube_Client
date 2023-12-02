//
//  HomepageViewModel.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import Combine
import GoogleAPIClientForREST_YouTube

/// A protocol that provides an interface for working with the View Model of the "Homepage" View Controller
protocol HomepageViewModel: AnyObject, VideoPresentingViewModel {
    var videosCategorySubject: CurrentValueSubject<String?, Never> { get }
    
    var videosListPublisher: AnyPublisher<[YouTubeVideoPreview], Never> { get }
    
    var dataLoadingPublisher: AnyPublisher<Bool, Never> { get }
    
    var retryLoadRecomendationsSubject: PassthroughSubject<Void, Never> { get }
    
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    var recomendedVideosCategories: [String] { get }
    
    func getRecomendations(for category: String) async throws
    
    func viewModelForCell(with videoPreview: YouTubeVideoPreview) -> VideoPreviewCellViewModel
}
