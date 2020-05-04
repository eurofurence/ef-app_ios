import Eurofurence
import EurofurenceModel
import XCTest

class DefaultAnnouncementDetailInteractorShould: XCTestCase {

    var context: AnnouncementDetailInteractorTestBuilder.Context!

    override func setUp() {
        super.setUp()
        
        let imagePNGData = "Strike a poke".data(using: .utf8).unsafelyUnwrapped
        context = AnnouncementDetailInteractorTestBuilder()
            .with(imagePNGData: imagePNGData)
            .build()
    }

    func testProduceViewModelUsingAnnouncementTitleAsHeading() {
        let viewModel = context.makeViewModel()
        XCTAssertEqual(context.announcement.title, viewModel?.heading)
    }

    func testProduceViewModelContentsUsingMarkdownRenderer() {
        let viewModel = context.makeViewModel()
        XCTAssertEqual(context.markdownRenderer.stubbedContents(for: context.announcement.content), viewModel?.contents)
    }

    func testProduceViewModelWithAnnouncementImage() {
        let viewModel = context.makeViewModel()
        XCTAssertEqual(context.announcement.imagePNGData, viewModel?.imagePNGData)
    }
    
    func testProduceInvalidAnnouncementViewModelWhenAnnouncementMissing() {
        let context = AnnouncementDetailInteractorTestBuilder().buildForMissingAnnouncement()
        let viewModel = context.makeViewModel()
        
        XCTAssertNotNil(viewModel)
        XCTAssertNil(viewModel?.imagePNGData)
        XCTAssertEqual(String.invalidAnnouncementAlertTitle, viewModel?.heading)
        XCTAssertEqual(context.markdownRenderer.stubbedContents(for: .invalidAnnouncementAlertMessage), viewModel?.contents)
    }

}
