import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Announcement {
    
    func assert(
        against actual: EurofurenceKit.Announcement,
        in managedObjectContext: NSManagedObjectContext,
        from response: SynchronizationPayload
    ) throws {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(validFromDateTimeUtc, actual.validFrom)
        XCTAssertEqual(validUntilDateTimeUtc, actual.validUntil)
        XCTAssertEqual(area, actual.area)
        XCTAssertEqual(author, actual.author)
        XCTAssertEqual(title, actual.title)
        XCTAssertEqual(content, actual.contents)
        
        if let imageIdentifier = imageIdentifier {
            let expectedImage = try response.image(identifiedBy: imageIdentifier)
            let image = try XCTUnwrap(
                actual.image,
                "Response indicated an image is present, but one was not bound to the announcement"
            )
            
            expectedImage.assert(against: image)
        }
    }
    
}
