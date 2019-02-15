//
//  DefaultKnowledgeDetailSceneInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class FakeKnowledgeService: KnowledgeService {

    func add(_ observer: KnowledgeServiceObserver) {

    }

    private var stubbedKnowledgeEntries = [KnowledgeEntryIdentifier: KnowledgeEntry]()
    func fetchKnowledgeEntry(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntry) -> Void) {
        completionHandler(stubbedKnowledgeEntry(for: identifier))
    }

    func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntryIdentifier, completionHandler: @escaping ([Data]) -> Void) {
        completionHandler(stubbedKnowledgeEntryImages(for: identifier))
    }

    private var stubbedGroups = [KnowledgeGroup]()
    func fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier, completionHandler: @escaping (KnowledgeGroup) -> Void) {
        stubbedGroups.first(where: { $0.identifier == identifier }).let(completionHandler)
    }

}

extension FakeKnowledgeService {

    func stubbedKnowledgeEntry(for identifier: KnowledgeEntryIdentifier) -> KnowledgeEntry {
        if let entry = stubbedKnowledgeEntries[identifier] {
            return entry
        }

        var randomEntry = KnowledgeEntry.random
        randomEntry.identifier = identifier
        stubbedKnowledgeEntries[identifier] = randomEntry

        return randomEntry
    }

    func stub(_ group: KnowledgeGroup) {
        stubbedGroups.append(group)
    }

    func stubbedKnowledgeEntryImages(for identifier: KnowledgeEntryIdentifier) -> [Data] {
        return [identifier.rawValue.data(using: .utf8)!]
    }

}

class DefaultKnowledgeDetailSceneInteractorTests: XCTestCase {

    var knowledgeService: FakeKnowledgeService!
    var renderer: StubMarkdownRenderer!
    var interactor: DefaultKnowledgeDetailSceneInteractor!

    override func setUp() {
        super.setUp()

        renderer = StubMarkdownRenderer()
        knowledgeService = FakeKnowledgeService()
        interactor = DefaultKnowledgeDetailSceneInteractor(knowledgeService: knowledgeService,
                                                           renderer: renderer)
    }

    func testProducingViewModelConvertsKnowledgeEntryContentsViaWikiRenderer() {
        let entry = KnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
		let expected = renderer.stubbedContents(for: randomizedEntry.contents)

        XCTAssertEqual(expected, viewModel?.contents)
    }

    func testProducingViewModelConvertsLinksIntoViewModels() {
        let entry = KnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let expected = randomizedEntry.links.map { (link) in return LinkViewModel(name: link.name) }

        XCTAssertEqual(expected, viewModel?.links)
    }

    func testRequestingLinkAtIndexReturnsExpectedLink() {
        let entry = KnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let randomLink = randomizedEntry.links.randomElement()
        let expected = randomLink.element
        let actual = viewModel?.link(at: randomLink.index)

        XCTAssertEqual(expected.name, actual?.name)
    }

    func testUsesTitlesOfEntryAsTitle() {
        let entry = KnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)

        XCTAssertEqual(randomizedEntry.title, viewModel?.title)
    }

    func testAdaptsImagesFromService() {
        let entry = KnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let expected = knowledgeService.stubbedKnowledgeEntryImages(for: entry.identifier).map(KnowledgeEntryImageViewModel.init)

        XCTAssertEqual(expected, viewModel?.images)
    }

}
