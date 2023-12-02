//
//  HomepageCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

import GoogleAPIClientForREST_YouTube

/// "Homepage" module flow coordinator implementation
final class HomepageCoordinatorImpl: BaseCoordinatorImpl, HomepageCoordinator {
    
    //MARK: Properties
    
    var finishFlow: VoidClosure?
    
    let router: Router
    let assemblyBuilder: AssemblyBuilder
    private let coordinatorsFactory: CoordinatorsFactory
    
    //MARK: - Initialization
    
    init(router: Router,
         coordinatorsFactory: CoordinatorsFactory,
         assemblyBuilder: AssemblyBuilder) {
        self.router = router
        self.coordinatorsFactory = coordinatorsFactory
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        let module = assemblyBuilder.buildHomepageModule(coordinator: self)
        router.setRootModule(module, animated: false)
    }
}
