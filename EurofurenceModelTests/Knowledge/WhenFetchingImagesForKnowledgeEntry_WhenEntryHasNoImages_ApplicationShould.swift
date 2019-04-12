import EurofurenceModel
import XCTest

class WhenFetchingImagesForKnowledgeEntry_WhenEntryHasNoImages_ApplicationShould: XCTestCase {

    func testInvokeTheHandlerWithEmptyImages() {
        let context = EurofurenceSessionTestBuilder().build()
        var images: [Data]?
        context.knowledgeService.fetchImagesForKnowledgeEntry(identifier: .random) { images = $0 }

        XCTAssertEqual([], images)
    }

}
