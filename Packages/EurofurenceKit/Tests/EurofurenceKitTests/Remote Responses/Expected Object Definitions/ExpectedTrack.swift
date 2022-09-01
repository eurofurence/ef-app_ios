@testable import EurofurenceKit
import class EurofurenceWebAPI.EurofurenceISO8601DateFormatter
import Foundation
import XCTest

struct ExpectedTrack {
    
    var lastUpdated: Date
    var identifier: String
    var name: String
    
    init(
        lastUpdated: String,
        identifier: String,
        name: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.name = name
    }
    
    func assert(against actual: Track) {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(name, actual.name)
    }
    
}
