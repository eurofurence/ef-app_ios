@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Dealer {
    
    func assert(
        against actual: EurofurenceKit.Dealer,
        in managedObjectContext: NSManagedObjectContext,
        from response: SynchronizationPayload
    ) throws {
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(registrationNumber, Int(actual.registrationNumber))
        XCTAssertEqual(attendeeNickname, actual.attendeeNickname)
        XCTAssertEqual(displayName, actual.displayName)
        XCTAssertEqual(merchandise, actual.merchanise)
        XCTAssertEqual(shortDescription, actual.dealerShortDescription)
        XCTAssertEqual(aboutTheArtistText, actual.aboutTheArtist)
        XCTAssertEqual(aboutTheArtText, actual.aboutTheArt)
        XCTAssertEqual(twitterHandle, actual.twitterHandle)
        XCTAssertEqual(telegramHandle, actual.telegramHandle)
        XCTAssertEqual(attendsOnThursday, actual.thursdayAttendance)
        XCTAssertEqual(attendsOnFriday, actual.fridayAttendance)
        XCTAssertEqual(attendsOnSaturday, actual.saturdayAttendance)
        XCTAssertEqual(isAfterDark, actual.isAfterDark)
        
        if let artPreviewImageIdentifier = artPreviewImageId {
            let artPreview = try XCTUnwrap(actual.artPreview)
            let expectedArtPreviewImage = try response.image(identifiedBy: artPreviewImageIdentifier)
            XCTAssertEqual(artPreviewCaption, artPreview.caption)
            expectedArtPreviewImage.assert(against: artPreview)
        }
        
        if let artistThumbnailImageIdentifier = artistThumbnailImageId {
            let thumbnail = try XCTUnwrap(
                actual.thumbnail,
                "Response contained a thumbnail ID, but the entity did not contain a thumbnail"
            )
            
            let thumbnailImage = try response.image(identifiedBy: artistThumbnailImageIdentifier)
            thumbnailImage.assert(against: thumbnail)
        }
        
        if let artistImageIdentifier = artistImageId {
            let image = try XCTUnwrap(
                actual.artistImage,
                "Response contained an artist image ID, but the entity did not contain an image"
            )
            
            let expectedImage = try response.image(identifiedBy: artistImageIdentifier)
            expectedImage.assert(against: image)
        }
        
        if let links = links {
            XCTAssertEqual(links.count, actual.links.count)
            
            for link in links {
                let actualLink = try XCTUnwrap(actual.links.first(where: { $0.target == link.target }))
                XCTAssertEqual(link.fragmentType, actualLink.fragmentType)
                XCTAssertEqual(link.name, actualLink.name)
            }
        }
    }
    
}
