import EurofurenceModel
import XCTest

class WhenFetchingIconDataForDealerWithArtwork_ApplicationShould: XCTestCase {

    func testReturnTheArtworkFromTheImageAPIForTheArtistThumbnailIdentifier() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dealer = syncResponse.dealers.changed.randomElement().element
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let expected = context.api.stubbedImage(
            for: dealer.artistThumbnailImageId,
            availableImages: syncResponse.images.changed
        )
        
        var artworkData: Data?
        let entity = context.dealersService.fetchDealer(for: DealerIdentifier(dealer.identifier))
        entity?.fetchIconPNGData { artworkData = $0 }

        XCTAssertEqual(expected, artworkData)
    }

}
