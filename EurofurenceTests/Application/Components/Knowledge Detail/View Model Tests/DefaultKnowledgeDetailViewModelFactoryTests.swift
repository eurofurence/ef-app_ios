import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DefaultKnowledgeDetailViewModelFactoryTests: XCTestCase {

    var entry: FakeKnowledgeEntry!
    var knowledgeService: FakeKnowledgeService!
    var renderer: StubMarkdownRenderer!
    var shareService: CapturingShareService!
    var viewModel: KnowledgeEntryDetailViewModel?

    override func setUp() {
        super.setUp()

        entry = FakeKnowledgeEntry.random
        knowledgeService = FakeKnowledgeService()
        knowledgeService.stub(entry)
        
        renderer = StubMarkdownRenderer()
        shareService = CapturingShareService()
        
        let viewModelFactory = DefaultKnowledgeDetailViewModelFactory(
            knowledgeService: knowledgeService,
            renderer: renderer,
            shareService: shareService
        )
        
        viewModelFactory.makeViewModel(for: entry.identifier) { self.viewModel = $0 }
    }

    func testProducingViewModelConvertsKnowledgeEntryContentsViaWikiRenderer() {
		let expected = renderer.stubbedContents(for: entry.contents)
        XCTAssertEqual(expected, viewModel?.contents)
    }

    func testProducingViewModelConvertsLinksIntoViewModels() {
        let expected = entry.links.map { (link) in return LinkViewModel(name: link.name) }
        XCTAssertEqual(expected, viewModel?.links)
    }

    func testRequestingLinkAtIndexReturnsExpectedLink() {
        let randomLink = entry.links.randomElement()
        let expected = randomLink.element
        let actual = viewModel?.link(at: randomLink.index)

        XCTAssertEqual(expected.name, actual?.name)
    }

    func testUsesTitlesOfEntryAsTitle() {
        XCTAssertEqual(entry.title, viewModel?.title)
    }

    func testAdaptsImagesFromService() {
        let imagesData = knowledgeService.stubbedKnowledgeEntryImages(for: entry.identifier)
        let expected = imagesData.map(KnowledgeEntryImageViewModel.init)

        XCTAssertEqual(expected, viewModel?.images)
    }
    
    func testSharingEntrySubmitsURLAndSenderToShareService() {
        let sender = self
        viewModel?.shareKnowledgeEntry(sender)
        let sharedItem = shareService.sharedItem as? KnowledgeEntryActivityItemSource
        
        XCTAssertEqual(KnowledgeEntryActivityItemSource(knowledgeEntry: entry), sharedItem)
        XCTAssertTrue(sender === (shareService.sharedItemSender as AnyObject))
    }

}
