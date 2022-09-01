@testable import EurofurenceKit
import Foundation
import XCTest

struct ExpectedDealer {
    
    var lastUpdated: Date
    var identifier: String
    var registrationNumber: Int
    var nickname: String
    var displayName: String
    var merchandiseDescription: String
    var shortDescription: String
    var aboutTheArtistDescription: String
    var aboutTheArtDescription: String
    var links: [ExpectedLink]
    var twitterHandle: String
    var telegramHandle: String
    var thursdayAttendence: Bool
    var fridayAttendence: Bool
    var saturdayAttendence: Bool
    var artPreviewCaption: String
    var artistThumbnailImageIdentifier: String?
    var artistImageIdentifier: String?
    var artPreviewImageIdentifier: String?
    var isAfterDark: Bool
    var categories: [String]
    
    init(
        lastUpdated: String,
        identifier: String,
        registrationNumber: Int,
        nickname: String,
        displayName: String,
        merchandiseDescription: String,
        shortDescription: String,
        aboutTheArtistDescription: String,
        aboutTheArtDescription: String,
        links: [ExpectedLink],
        twitterHandle: String,
        telegramHandle: String,
        thursdayAttendence: Bool,
        fridayAttendence: Bool,
        saturdayAttendence: Bool,
        artPreviewCaption: String,
        artistThumbnailImageIdentifier: String?,
        artistImageIdentifier: String?,
        artPreviewImageIdentifier: String?,
        isAfterDark: Bool,
        categories: [String]
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.registrationNumber = registrationNumber
        self.nickname = nickname
        self.displayName = displayName
        self.merchandiseDescription = merchandiseDescription
        self.shortDescription = shortDescription
        self.aboutTheArtistDescription = aboutTheArtistDescription
        self.aboutTheArtDescription = aboutTheArtDescription
        self.links = links
        self.twitterHandle = twitterHandle
        self.telegramHandle = telegramHandle
        self.thursdayAttendence = thursdayAttendence
        self.fridayAttendence = fridayAttendence
        self.saturdayAttendence = saturdayAttendence
        self.artPreviewCaption = artPreviewCaption
        self.artistThumbnailImageIdentifier = artistThumbnailImageIdentifier
        self.artistImageIdentifier = artistImageIdentifier
        self.artPreviewImageIdentifier = artPreviewImageIdentifier
        self.isAfterDark = isAfterDark
        self.categories = categories
    }
    
    func assert<R>(
        against actual: Dealer,
        in managedObjectContext: NSManagedObjectContext,
        from response: R
    ) throws where R: SyncResponseFile {
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(registrationNumber, Int(actual.registrationNumber))
        XCTAssertEqual(nickname, actual.attendeeNickname)
        XCTAssertEqual(displayName, actual.displayName)
        XCTAssertEqual(merchandiseDescription, actual.merchanise)
        XCTAssertEqual(shortDescription, actual.dealerShortDescription)
        XCTAssertEqual(aboutTheArtistDescription, actual.aboutTheArtist)
        XCTAssertEqual(aboutTheArtDescription, actual.aboutTheArt)
        XCTAssertEqual(twitterHandle, actual.twitterHandle)
        XCTAssertEqual(telegramHandle, actual.telegramHandle)
        XCTAssertEqual(thursdayAttendence, actual.thursdayAttendance)
        XCTAssertEqual(fridayAttendence, actual.fridayAttendance)
        XCTAssertEqual(saturdayAttendence, actual.saturdayAttendance)
        XCTAssertEqual(isAfterDark, actual.isAfterDark)
        
        if let artPreviewImageIdentifier = artPreviewImageIdentifier {
            let artPreview = try XCTUnwrap(actual.artPreview)
            let expectedArtPreviewImage = try response.image(identifiedBy: artPreviewImageIdentifier)
            XCTAssertEqual(artPreviewCaption, artPreview.caption)
            expectedArtPreviewImage.assert(against: artPreview)
        }
        
        if let artistThumbnailImageIdentifier = artistThumbnailImageIdentifier {
            let thumbnail = try XCTUnwrap(
                actual.thumbnail,
                "Response contained a thumbnail ID, but the entity did not contain a thumbnail"
            )
            
            let thumbnailImage = try response.image(identifiedBy: artistThumbnailImageIdentifier)
            thumbnailImage.assert(against: thumbnail)
        }
        
        if let artistImageIdentifier = artistImageIdentifier {
            let image = try XCTUnwrap(
                actual.artistImage,
                "Response contained an artist image ID, but the entity did not contain an image"
            )
            
            let expectedImage = try response.image(identifiedBy: artistImageIdentifier)
            expectedImage.assert(against: image)
        }
        
        XCTAssertEqual(links.count, actual.links.count)
        
        for link in links {
            let actualLink = try XCTUnwrap(actual.links.first(where: { $0.target == link.target }))
            XCTAssertEqual(link.fragmentType, actualLink.fragmentType)
            XCTAssertEqual(link.name, actualLink.name)
        }
    }
    
}
