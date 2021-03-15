import EurofurenceApplication
import EurofurenceModel
import XCTest

class DefaultAnnouncementDetailViewModelFactoryShould: XCTestCase {

    func testProduceViewModelUsingAnnouncementAttributes() {
        let imagePNGData = "Strike a poke".data(using: .utf8).unsafelyUnwrapped
        let context = AnnouncementDetailViewModelFactoryTestBuilder()
            .with(imagePNGData: imagePNGData)
            .build()
        
        let viewModel = context.makeViewModel()
        
        XCTAssertEqual(context.announcement.title, viewModel?.heading)
        XCTAssertEqual(context.markdownRenderer.stubbedContents(for: context.announcement.content), viewModel?.contents)
        XCTAssertEqual(context.announcement.imagePNGData, viewModel?.imagePNGData)
    }
    
    func testProduceInvalidAnnouncementViewModelWhenAnnouncementMissing() {
        let context = AnnouncementDetailViewModelFactoryTestBuilder().buildForMissingAnnouncement()
        let viewModel = context.makeViewModel()
        let expectedContents = context.markdownRenderer.stubbedContents(for: .invalidAnnouncementAlertMessage)
        
        XCTAssertNotNil(viewModel)
        XCTAssertNil(viewModel?.imagePNGData)
        XCTAssertEqual(String.invalidAnnouncementAlertTitle, viewModel?.heading)
        XCTAssertEqual(expectedContents, viewModel?.contents)
    }

}
