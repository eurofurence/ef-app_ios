@testable import EurofurenceKit
import Foundation
import XCTest

struct ExpectedEvent {
    
    var lastUpdated: Date
    var identifier: String
    var slug: String
    var dayIdentifier: String
    var title: String
    var subtitle: String
    var abstract: String
    var trackIdentifier: String
    var roomIdentifier: String
    var description: String
    var startDate: Date
    var endDate: Date
    var panelHosts: [String]
    var deviatingFromConbook: Bool
    var acceptingFeedback: Bool
    
    init(
        lastUpdated: String,
        identifier: String,
        slug: String,
        title: String,
        subtitle: String,
        abstract: String,
        dayIdentifier: String,
        trackIdentifier: String,
        roomIdentifier: String,
        description: String,
        startDate: String,
        endDate: String,
        panelHosts: [String],
        deviatingFromConbook: Bool,
        acceptingFeedback: Bool
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.slug = slug
        self.dayIdentifier = dayIdentifier
        self.title = title
        self.subtitle = subtitle
        self.abstract = abstract
        self.dayIdentifier = dayIdentifier
        self.trackIdentifier = trackIdentifier
        self.roomIdentifier = roomIdentifier
        self.description = description
        self.startDate = dateFormatter.date(from: startDate)!
        self.endDate = dateFormatter.date(from: endDate)!
        self.panelHosts = panelHosts
        self.deviatingFromConbook = deviatingFromConbook
        self.acceptingFeedback = acceptingFeedback
    }
    
    func assert(against actual: Event, in managedObjectContext: NSManagedObjectContext) throws {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(slug, actual.slug)
        XCTAssertEqual(title, actual.title)
        XCTAssertEqual(subtitle, actual.subtitle)
        XCTAssertEqual(abstract, actual.abstract)
        XCTAssertEqual(description, actual.eventDescription)
        XCTAssertEqual(startDate, actual.startDate)
        XCTAssertEqual(endDate, actual.endDate)
        XCTAssertEqual(deviatingFromConbook, actual.deviatingFromConbook)
        XCTAssertEqual(acceptingFeedback, actual.acceptingFeedback)
        
        let day = try XCTUnwrap(actual.day)
        XCTAssertEqual(day.identifier, dayIdentifier)
        XCTAssertTrue(day.events.contains(actual))
        
        let room = try XCTUnwrap(actual.room)
        XCTAssertEqual(room.identifier, roomIdentifier)
        XCTAssertTrue(room.events.contains(actual))
        
        let track: Track = try managedObjectContext.entity(withIdentifier: trackIdentifier)
        XCTAssertTrue(actual.tracks.contains(track))
        XCTAssertTrue(track.events.contains(actual))
        
        for host in panelHosts {
            let matchingHost = try XCTUnwrap(actual.panelHosts.first(where: { $0.name == host }))
            XCTAssertTrue(matchingHost.hostingEvents.contains(actual))
        }
    }
    
}
