//
//  BeforeKnowledgeGroupEntriesSceneLoads.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class BeforeKnowledgeGroupEntriesSceneLoads: XCTestCase {
    
    func testNoBindingsOccurOntoTheScene() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        XCTAssertNil(context.sceneFactory.scene.capturedNumberOfEntriesToBind)
    }
    
}
