//
//  WhenKnowledgeGroupEntriesSceneLoads.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenKnowledgeGroupEntriesSceneLoads: XCTestCase {
    
    func testTheNumberOfEntriesFromTheViewModelAreBoundOntoTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.viewModel.numberOfEntries, context.sceneFactory.scene.capturedNumberOfEntriesToBind)
    }
    
    func testTheTitleFromTheViewModelIsBoundOntoTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.viewModel.title, context.sceneFactory.scene.capturedTitle)
    }
    
}
