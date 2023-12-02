//
//  ShortsCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.05.2023.
//

/// "Shorts" module flow coordinator implementation
final class ShortsCoordinatorImpl: BaseCoordinatorImpl, ShortsCoordinator {
    
    //MARK: Properties
    
    var finishFlow: VoidClosure?
    
    private let router: Router
    private let coordinatorsFactory: CoordinatorsFactory
    private let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(router: Router,
         coordinatorsFactory: CoordinatorsFactory,
         assemblyBuilder: AssemblyBuilder) {
        self.router = router
        self.coordinatorsFactory = coordinatorsFactory
        self.assemblyBuilder = assemblyBuilder
    }
    
    override func start(with item: Any?) {
        let module = assemblyBuilder.buildShortsModule(coordinator: self)
        router.setRootModule(module, animated: false)
    }
}
