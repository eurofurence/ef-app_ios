@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DefaultKnowledgeDetailViewModelFactoryTests: XCTestCase {

    var knowledgeService: FakeKnowledgeService!
    var renderer: StubMarkdownRenderer!
    var shareService: CapturingShareService!
    var interactor: DefaultKnowledgeDetailViewModelFactory!

    override func setUp() {
        super.setUp()

        renderer = StubMarkdownRenderer()
        knowledgeService = FakeKnowledgeService()
        shareService = CapturingShareService()
        interactor = DefaultKnowledgeDetailViewModelFactory(knowledgeService: knowledgeService,
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
