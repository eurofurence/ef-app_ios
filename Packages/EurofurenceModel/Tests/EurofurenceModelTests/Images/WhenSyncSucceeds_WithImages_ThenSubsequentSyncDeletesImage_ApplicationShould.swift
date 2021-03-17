import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSyncSucceeds_WithImages_ThenSubsequentSyncDeletesImage_ApplicationShould: XCTestCase {

    func testDeleteTheImageFromTheStore() {
        let dataStore = InMemoryDataStore()
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let imageToDelete = syncResponse.images.changed.randomElement().element
        syncResponse.images.changed.removeAll()
        syncResponse.images.deleted = [imageToDelete.identifier]
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertEqual(false, dataStore.fetchImages()?.contains(imageToDelete))
        XCTAssertTrue(context.imageRepository.deletedImages.contains(imageToDelete.identifier))
    }

}
