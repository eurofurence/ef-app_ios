//
//  DefaultKnowledgeDetailSceneInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FakeKnowledgeService: KnowledgeService {
    
    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        
    }
    
    private var stubbedKnowledgeEntries = [KnowledgeEntry2.Identifier : KnowledgeEntry2]()
    func fetchKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntry2) -> Void) {
        completionHandler(stubbedKnowledgeEntry(for: identifier))
    }
    
}

extension FakeKnowledgeService {
    
    func stubbedKnowledgeEntry(for identifier: KnowledgeEntry2.Identifier) -> KnowledgeEntry2 {
        if let entry = stubbedKnowledgeEntries[identifier] {
            return entry
        }
        
        var randomEntry = KnowledgeEntry2.random
        randomEntry.identifier = identifier
        stubbedKnowledgeEntries[identifier] = randomEntry
        
        return randomEntry
    }
    
}

class DefaultKnowledgeDetailSceneInteractorTests: XCTestCase {
    
    var knowledgeService: FakeKnowledgeService!
    var renderer: StubWikiRenderer!
    var interactor: DefaultKnowledgeDetailSceneInteractor!
    
    override func setUp() {
        super.setUp()
        
        renderer = StubWikiRenderer()
        knowledgeService = FakeKnowledgeService()
        interactor = DefaultKnowledgeDetailSceneInteractor(knowledgeService: knowledgeService,
                                                           renderer: renderer)
    }
    
    func testProducingViewModelConvertsKnowledgeEntryContentsViaWikiRenderer() {
        let entry = KnowledgeEntry2.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let expected = renderer.stubbedEntryContents[randomizedEntry.contents]
        
        XCTAssertEqual(expected, viewModel?.contents)
    }
    
    func testProducingViewModelConvertsLinksIntoViewModels() {
        let entry = KnowledgeEntry2.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let expected = randomizedEntry.links.map { (link) in return LinkViewModel(name: link.name) }
        
        XCTAssertEqual(expected, viewModel?.links)
    }
    
}
