@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Event {
    
    func assert(
        against actual: EurofurenceKit.Event,
        in managedObjectContext: NSManagedObjectContext,
        from response: SynchronizationPayload
    ) throws {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(slug, actual.slug)
        XCTAssertEqual(title, actual.title)
        XCTAssertEqual(subtitle, actual.subtitle)
        XCTAssertEqual(abstract, actual.abstract)
        XCTAssertEqual(description, actual.eventDescription)
        XCTAssertEqual(startDateTimeUtc, actual.startDate)
        XCTAssertEqual(endDateTimeUtc, actual.endDate)
        XCTAssertEqual(isDeviatingFromConBook, actual.deviatingFromConbook)
        XCTAssertEqual(isAcceptingFeedback, actual.acceptingFeedback)
        
        let day = try XCTUnwrap(actual.day)
        XCTAssertEqual(day.identifier, dayIdentifier)
        XCTAssertTrue(day.events.contains(actual))
        
        let room = try XCTUnwrap(actual.room)
        XCTAssertEqual(room.identifier, roomIdentifier)
        XCTAssertTrue(room.events.contains(actual))
        
        let track: EurofurenceKit.Track = try managedObjectContext.entity(withIdentifier: trackIdentifier)
        XCTAssertTrue(actual.tracks.contains(track))
        
        let panelHosts = panelHostsSeperatedByComma.components(separatedBy: ",")
        for host in panelHosts {
            let trimmedHost = host.trimmingCharacters(in: .whitespaces)
            let matchingHost = try XCTUnwrap(actual.panelHosts.first(where: { $0.name == trimmedHost }), "Could not find host \(trimmedHost)")
            XCTAssertTrue(matchingHost.hostingEvents.contains(actual))
        }
        
        for tag in tags {
            let matchingTag = try XCTUnwrap(actual.tags.first(where: { $0.name == tag }))
            XCTAssertTrue(matchingTag.events.contains(actual))
        }
        
        if let bannerImageIdentifier = bannerImageIdentifier {
            let expectedImage = try response.image(identifiedBy: bannerImageIdentifier)
            let banner: EventBanner = try managedObjectContext.entity(withIdentifier: bannerImageIdentifier)
            expectedImage.assert(against: banner)
            XCTAssertEqual(banner, actual.banner)
        }
        
        if let posterImageIdentifier = posterImageIdentifier {
            let expectedImage = try response.image(identifiedBy: posterImageIdentifier)
            let poster: EventPoster = try managedObjectContext.entity(withIdentifier: posterImageIdentifier)
            expectedImage.assert(against: poster)
            XCTAssertEqual(poster, actual.poster)
        }
    }
    
}
