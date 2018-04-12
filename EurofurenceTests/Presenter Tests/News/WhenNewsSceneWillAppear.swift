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
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel?.components.count, context.newsScene.capturedComponentsToBind)
    }
    
    func testTheNewsSceneIsToldToBindExpectedSubcomponentItemCountsFromViewModel() {
        let viewModel = context.newsInteractor.lastCreatedViewModel
        let expected = viewModel?.components.map({ $0.numberOfItems }) ?? []
        
        XCTAssertEqual(expected, context.newsScene.capturedNumberOfItemsPerComponentToBind)
    }
    
}
