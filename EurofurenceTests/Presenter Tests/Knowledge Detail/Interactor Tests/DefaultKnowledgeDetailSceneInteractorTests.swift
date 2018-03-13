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
    
    var renderer: StubWikiRenderer!
    var interactor: DefaultKnowledgeDetailSceneInteractor!
    
    override func setUp() {
        super.setUp()
        
        renderer = StubWikiRenderer()
        interactor = DefaultKnowledgeDetailSceneInteractor(renderer: renderer)
    }
    
    func testProducingViewModelConvertsKnowledgeEntryContentsViaWikiRenderer() {
        let expected = NSAttributedString.random
        let entry = KnowledgeEntry2.random
        renderer.stub(entry, with: expected)
        let viewModel = interactor.makeViewModel(for: entry)
        
        XCTAssertEqual(expected, viewModel.contents)
    }
    
    func testProducingViewModelConvertsLinksIntoViewModels() {
        let entry = KnowledgeEntry2.random
        let viewModel = interactor.makeViewModel(for: entry)
        let expected = entry.links.map { (link) in return LinkViewModel(name: link.name) }
        
        XCTAssertEqual(expected, viewModel.links)
    }
    
}
