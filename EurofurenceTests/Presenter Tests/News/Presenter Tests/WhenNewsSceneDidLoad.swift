//
//  WhenNewsSceneDidLoad.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenNewsSceneDidLoad: XCTestCase {
    
    var context: NewsPresenterTestBuilder.Context!
    var newsInteractor: FakeNewsInteractor!
    
    override func setUp() {
        super.setUp()
        
        newsInteractor = FakeNewsInteractor()
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
    }
    
    func testTheNewsSceneIsToldToBindExpectedNumberOfComponentsFromViewModel() {
        let viewModel = newsInteractor.lastCreatedViewModel
        XCTAssertEqual(viewModel.components.count, context.newsScene.capturedComponentsToBind)
    }
    
    func testTheNewsSceneIsToldToBindExpectedSubcomponentItemCountsFromViewModel() {
        let viewModel = newsInteractor.lastCreatedViewModel
        let expected = viewModel.components.map({ $0.numberOfItems })
        
        XCTAssertEqual(expected, context.newsScene.capturedNumberOfItemsPerComponentToBind)
    }
    
    func testBindingTitleForSectionAppliesTitleFromViewModelOntoScene() {
        let viewModel = newsInteractor.lastCreatedViewModel
        let component = viewModel.components.randomElement()
        let titleScene = CapturingNewsComponentHeaderScene()
        context.newsScene.capturedBinder?.bindTitleForSection(at: component.index, scene: titleScene)
        
        XCTAssertEqual(component.element.title, titleScene.capturedTitle)
    }
    
}
