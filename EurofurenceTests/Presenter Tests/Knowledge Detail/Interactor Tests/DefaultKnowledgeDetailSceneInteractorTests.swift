//
//  DefaultKnowledgeDetailSceneInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultKnowledgeDetailSceneInteractorTests: XCTestCase {
    
    func testProducingViewModelConvertsKnowledgeEntryContentsViaWikiRenderer() {
        let expected = NSAttributedString.random
        let entry = KnowledgeEntry2.random
        let renderer = StubWikiRenderer()
        renderer.stub(entry, with: expected)
        let interactor = DefaultKnowledgeDetailSceneInteractor(renderer: renderer)
        let viewModel = interactor.makeViewModel(for: entry)
        
        XCTAssertEqual(expected, viewModel.contents)
    }
    
}
