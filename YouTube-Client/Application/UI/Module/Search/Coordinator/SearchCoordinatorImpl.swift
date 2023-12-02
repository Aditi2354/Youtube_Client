//
//  SearchCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 01.07.2023.
//

import GoogleAPIClientForREST_YouTube

enum SearchCoordinateAction {
    case backButtonTapped
    case viewDidDissappear
}

final class SearchCoordinatorImpl: BaseCoordinatorImpl, SearchCoordinator {
    
    //MARK: Properties
    
    var finishFlow: VoidClosure?
    let router: Router
    let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(router: Router, assemblyBuilder: AssemblyBuilder) {
        self.router = router
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        let module = assemblyBuilder.buildSearchModule(coordinator: self)
        router.push(module, animated: false, hideBottomBar: true)
    }
    
    func performCoordinate(for action: SearchCoordinateAction) {
        switch action {
        case .backButtonTapped:
            popModule()
        case .viewDidDissappear:
            finishFlow?()
        }
    }
}

private extension SearchCoordinatorImpl {
    func popModule() {
        finishFlow?()
        router.popModule(animated: true)
    }
}
