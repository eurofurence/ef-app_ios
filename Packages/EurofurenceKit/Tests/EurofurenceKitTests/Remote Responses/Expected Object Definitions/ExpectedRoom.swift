@testable import EurofurenceKit
import Foundation
import XCTest

struct ExpectedRoom {
    
    var lastUpdated: Date
    var identifier: String
    var name: String
    var shortName: String
    
    init(
        lastUpdated: String,
        identifier: String,
        name: String,
        shortName: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.name = name
        self.shortName = shortName
    }
    
    func assert(against actual: Room) {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(shortName, actual.shortName)
    }
    
}
