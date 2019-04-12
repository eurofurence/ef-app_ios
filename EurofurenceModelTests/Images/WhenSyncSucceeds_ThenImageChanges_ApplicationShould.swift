import EurofurenceModel
import XCTest

class WhenSyncSucceeds_ThenImageChanges_ApplicationShould: XCTestCase {

    class VerifyImageRedownloadedAPI: FakeAPI {

        func verifyDownloadedImage(identifier: String, count: Int, file: StaticString = #file, line: UInt = #line) {
            let actualCount = downloadedImageIdentifiers.filter({ $0 == identifier }).count
            XCTAssertEqual(count, actualCount, file: file, line: line)
        }

    }

    func testRedownloadTheImage() {

        let imageAPI = VerifyImageRedownloadedAPI()
        let context = EurofurenceSessionTestBuilder().with(imageAPI).build()
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        let changedImage = originalResponse.images.changed.randomElement()
        subsequentResponse.images.changed = [changedImage.element]
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        imageAPI.verifyDownloadedImage(identifier: changedImage.element.identifier, count: 2)
    }

}
