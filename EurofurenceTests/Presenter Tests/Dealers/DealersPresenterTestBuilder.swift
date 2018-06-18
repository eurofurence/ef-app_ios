//
//  DealersPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class DealersPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingDealersScene
    }
    
    private var interactor: DealersInteractor
    
    init() {
        interactor = FakeDealersInteractor(viewModel: CapturingDealersViewModel.random)
    }
    
    @discardableResult
    func with(_ interactor: DealersInteractor) -> DealersPresenterTestBuilder {
        self.interactor = interactor
        return self
    }
    
    func build() -> Context {
        let sceneFactory = StubDealersSceneFactory()
        let viewController = DealersModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .build()
            .makeDealersModule()
        
        return Context(producedViewController: viewController,
                       scene: sceneFactory.scene)
    }
    
}

extension DealersPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.dealersSceneDidLoad()
    }
    
    func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
        scene.binder?.bind(component, toDealerAt: indexPath)
    }
    
}
