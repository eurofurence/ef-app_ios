@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class FakeKnowledgeService: KnowledgeService {

    func add(_ observer: KnowledgeServiceObserver) {

    }

    private var stubbedKnowledgeEntries = [KnowledgeEntryIdentifier: FakeKnowledgeEntry]()
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

    func stubbedKnowledgeEntry(for identifier: KnowledgeEntryIdentifier) -> FakeKnowledgeEntry {
        if let entry = stubbedKnowledgeEntries[identifier] {
            return entry
        }

        let randomEntry = FakeKnowledgeEntry.random
        randomEntry.identifier = identifier
        stubbedKnowledgeEntries[identifier] = randomEntry

        return randomEntry
    }

    func stub(_ group: KnowledgeGroup) {
        stubbedGroups.append(group)
    }

    func stubbedKnowledgeEntryImages(for identifier: KnowledgeEntryIdentifier) -> [Data] {
        return [identifier.rawValue.data(using: .utf8).unsafelyUnwrapped]
    }

}

class DefaultKnowledgeDetailSceneInteractorTests: XCTestCase {

    var knowledgeService: FakeKnowledgeService!
    var renderer: StubMarkdownRenderer!
    var shareService: CapturingShareService!
    var interactor: DefaultKnowledgeDetailSceneInteractor!

    override func setUp() {
        super.setUp()

        renderer = StubMarkdownRenderer()
        knowledgeService = FakeKnowledgeService()
        shareService = CapturingShareService()
        interactor = DefaultKnowledgeDetailSceneInteractor(knowledgeService: knowledgeService,
                                                           renderer: renderer,
                                                           shareService: shareService)
    }

    func testProducingViewModelConvertsKnowledgeEntryContentsViaWikiRenderer() {
        let entry = FakeKnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
		let expected = renderer.stubbedContents(for: randomizedEntry.contents)

        XCTAssertEqual(expected, viewModel?.contents)
    }

    func testProducingViewModelConvertsLinksIntoViewModels() {
        let entry = FakeKnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let expected = randomizedEntry.links.map { (link) in return LinkViewModel(name: link.name) }

        XCTAssertEqual(expected, viewModel?.links)
    }

    func testRequestingLinkAtIndexReturnsExpectedLink() {
        let entry = FakeKnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)
        let randomLink = randomizedEntry.links.randomElement()
        let expected = randomLink.element
        let actual = viewModel?.link(at: randomLink.index)

        XCTAssertEqual(expected.name, actual?.name)
    }

    func testUsesTitlesOfEntryAsTitle() {
        let entry = FakeKnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let randomizedEntry = knowledgeService.stubbedKnowledgeEntry(for: entry.identifier)

        XCTAssertEqual(randomizedEntry.title, viewModel?.title)
    }

    func testAdaptsImagesFromService() {
        let entry = FakeKnowledgeEntry.random
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let expected = knowledgeService.stubbedKnowledgeEntryImages(for: entry.identifier).map(KnowledgeEntryImageViewModel.init)

        XCTAssertEqual(expected, viewModel?.images)
    }
    
    func testSharingEntrySubmitsURLAndSenderToShareService() {
        let identifier = KnowledgeEntryIdentifier.random
        let entry = knowledgeService.stubbedKnowledgeEntry(for: identifier)
        var viewModel: KnowledgeEntryDetailViewModel?
        interactor.makeViewModel(for: entry.identifier) { viewModel = $0 }
        let sender = self
        viewModel?.shareKnowledgeEntry(sender)
        
        XCTAssertEqual(entry.contentURL, shareService.sharedItem as? URL)
        XCTAssertTrue(sender === (shareService.sharedItemSender as AnyObject))
    }

}
