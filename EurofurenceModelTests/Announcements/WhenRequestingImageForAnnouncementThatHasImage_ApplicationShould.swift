import EurofurenceModel
import XCTest

class WhenRequestingImageForAnnouncementThatHasImage_ApplicationShould: XCTestCase {

    func testProvideTheImageData() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let announcement = syncResponse.announcements.changed.randomElement().element
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let expected = context.api.stubbedImage(for: announcement.imageIdentifier, availableImages: syncResponse.images.changed)
        let identifier = AnnouncementIdentifier(announcement.identifier)
        var actual: Data?
        let entity = context.announcementsService.fetchAnnouncement(identifier: identifier)
        entity?.fetchAnnouncementImagePNGData(completionHandler: { actual = $0 })

        XCTAssertEqual(expected, actual)
    }

}
