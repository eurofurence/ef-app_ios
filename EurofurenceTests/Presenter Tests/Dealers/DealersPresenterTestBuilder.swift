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
        var delegate: CapturingDealersModuleDelegate
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
        let delegate = CapturingDealersModuleDelegate()
        let viewController = DealersModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .build()
            .makeDealersModule(delegate)
        
        return Context(producedViewController: viewController,
                       scene: sceneFactory.scene,
                       delegate: delegate)
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
    
    func simulateSceneDidChangeSearchQuery(to query: String) {
        scene.delegate?.dealersSceneDidChangeSearchQuery(to: query)
    }
    
    func simulateSceneDidSelectDealer(at indexPath: IndexPath) {
        scene.delegate?.dealersSceneDidSelectDealer(at: indexPath)
    }
    
    func simulateSceneDidSelectSearchResult(at indexPath: IndexPath) {
        scene.delegate?.dealersSceneDidSelectDealerSearchResult(at: indexPath)
    }
    
    func simulateSceneDidPerformRefreshAction() {
        scene.delegate?.dealersSceneDidPerformRefreshAction()
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
    
    func makeAndBindComponentHeader(forSearchResultGroupAt index: Int) -> CapturingDealerGroupHeader {
        let component = CapturingDealerGroupHeader()
        bind(component, toDealerSearchResultGroupAt: index)
        return component
    }
    
    func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
        scene.binder?.bind(component, toDealerAt: indexPath)
    }
    
    func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int) {
        scene.binder?.bind(component, toDealerGroupAt: index)
    }
    
    func bind(_ component: DealerGroupHeader, toDealerSearchResultGroupAt index: Int) {
        scene.searchResultsBinder?.bind(component, toDealerSearchResultGroupAt: index)
    }
    
    func bind(_ component: DealerComponent, toDealerSearchResultAt indexPath: IndexPath) {
        scene.searchResultsBinder?.bind(component, toDealerSearchResultAt: indexPath)
    }
    
}
