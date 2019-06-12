import EurofurenceModel
import XCTest

class WhenFetchingImagesForKnowledgeEntry_WhenEntryHasImages_ApplicationShould: XCTestCase {

    func testProvideTheImageDataFromTheRepository() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomEntry = syncResponse.knowledgeEntries.changed.randomElement().element
        let images = randomEntry.imageIdentifiers
        let expected = images.compactMap(context.imageRepository.loadImage).map({ $0.pngImageData })
        var actual: [Data]?
        context.knowledgeService.fetchImagesForKnowledgeEntry(identifier: KnowledgeEntryIdentifier(randomEntry.identifier)) { actual = $0 }

        XCTAssertEqual(expected, actual)
    }

}
