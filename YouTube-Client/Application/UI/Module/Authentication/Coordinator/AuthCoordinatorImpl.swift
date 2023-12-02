//
//  AuthCoordinatorImpl.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 29.04.2023.
//

enum AuthCoordinateAction {
    case signIn
}

final class AuthCoordinatorImpl: BaseCoordinatorImpl, AuthCoordinator {
    
    //MARK: Properties
    
    var finishFlow: VoidClosure?
    
    private let router: Router
    private let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(router: Router, assemblyBuilder: AssemblyBuilder) {
        self.router = router
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        let module = assemblyBuilder.buildAuthModule(coordinator: self)
        router.setRootModule(module, animated: true)
    }
    
    func performCoordinate(for action: AuthCoordinateAction) {
        switch action {
        case .signIn:
            finishFlow?()
        }
    }
}
