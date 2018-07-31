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
    
    private var knowledgeGroupEntries = [KnowledgeGroup2.Identifier : [KnowledgeEntry2]]()
    func fetchKnowledgeEntriesForGroup(identifier: KnowledgeGroup2.Identifier, completionHandler: @escaping ([KnowledgeEntry2]) -> Void) {
        if let entries = knowledgeGroupEntries[identifier] {
            completionHandler(entries)
        }
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
    
    func stub(_ entries: [KnowledgeEntry2], for identifier: KnowledgeGroup2.Identifier) {
        knowledgeGroupEntries[identifier] = entries
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
    
    func testRequestingLinkAtIndexReturnsExpectedLink() {
        let entry = KnowledgeEntry2.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let randomLink = randomizedEntry.links.randomElement()
        let expected = randomLink.element
        let actual = viewModel?.link(at: randomLink.index)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testUsesTitlesOfEntryAsTitle() {
        let entry = KnowledgeEntry2.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        
        XCTAssertEqual(randomizedEntry.title, viewModel?.title)
    }
    
}
