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

class CapturingDealerGroupHeader: DealerGroupHeader {
    
    private(set) var capturedDealersGroupTitle: String?
    func setDealersGroupTitle(_ title: String) {
        capturedDealersGroupTitle = title
    }
    
}

extension DealersPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.dealersSceneDidLoad()
    }
    
    func makeAndBindDealer(at indexPath: IndexPath) -> CapturingDealerComponent {
        let component = CapturingDealerComponent()
        bind(component, toDealerAt: indexPath)
        return component
    }
    
    func makeAndBindComponentHeader(at index: Int) -> CapturingDealerGroupHeader {
        let component = CapturingDealerGroupHeader()
        bind(component, toDealerGroupAt: index)
        return component
    }
    
    func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
        scene.binder?.bind(component, toDealerAt: indexPath)
    }
    
    func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int) {
        scene.binder?.bind(component, toDealerGroupAt: index)
    }
    
}
