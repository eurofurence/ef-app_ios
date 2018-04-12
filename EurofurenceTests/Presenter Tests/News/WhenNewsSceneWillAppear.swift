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
    
    func testTheNewsSceneIsToldToBindExpectedNumberOfComponentsFromViewModel() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        let viewModel = context.newsInteractor.lastCreatedViewModel
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel?.components.count, context.newsScene.capturedComponentsToBind)
    }
    
    func testTheNewsSceneIsToldToBindExpectedSubcomponentItemCountsFromViewModel() {
        let context = NewsPresenterTestBuilder().build()
        context.simulateNewsSceneWillAppear()
        let viewModel = context.newsInteractor.lastCreatedViewModel
        let expected = viewModel?.components.map({ $0.numberOfItems }) ?? []
        
        XCTAssertEqual(expected, context.newsScene.capturedNumberOfItemsPerComponentToBind)
    }
    
}
