//
//  WhenNewsSceneWillAppear.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenNewsSceneWillAppear: XCTestCase {
    
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
    }
    
    func testTheNewsSceneIsToldToBindExpectedNumberOfComponentsFromViewModel() {
        let viewModel = context.newsInteractor.lastCreatedViewModel        
        XCTAssertEqual(viewModel.components.count, context.newsScene.capturedComponentsToBind)
    }
    
    func testTheNewsSceneIsToldToBindExpectedSubcomponentItemCountsFromViewModel() {
        let viewModel = context.newsInteractor.lastCreatedViewModel
        let expected = viewModel.components.map({ $0.numberOfItems })
        
        XCTAssertEqual(expected, context.newsScene.capturedNumberOfItemsPerComponentToBind)
    }
    
    func testBindingTitleForSectionAppliesTitleFromViewModelOntoScene() {
        let viewModel = context.newsInteractor.lastCreatedViewModel
        let component = viewModel.components.randomElement()
        let titleScene = CapturingNewsComponentHeaderScene()
        context.newsScene.capturedBinder?.bindTitleForSection(at: component.index, scene: titleScene)
        
        XCTAssertEqual(component.element.title, titleScene.capturedTitle)
    }
    
}
