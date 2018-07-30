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
        let viewModel = StubKnowledgeGroupEntriesViewModel.random
        let groupIdentifier = KnowledgeGroup2.Identifier.random
        let interactor = FakeKnowledgeGroupEntriesInteractor(for: groupIdentifier, viewModel: viewModel)
        let sceneFactory = StubKnowledgeGroupEntriesSceneFactory()
        _ = KnowledgeGroupEntriesModuleBuilder()
            .with(interactor)
            .with(sceneFactory)
            .build()
            .makeKnowledgeGroupEntriesModule(groupIdentifier)
        
        XCTAssertNil(sceneFactory.scene.capturedNumberOfEntriesToBind)
    }
    
}
