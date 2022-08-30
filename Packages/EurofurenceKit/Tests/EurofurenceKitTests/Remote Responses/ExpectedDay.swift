@testable import EurofurenceKit
import Foundation
import XCTest

struct ExpectedDay {
    
    var lastUpdated: Date
    var identifier: String
    var name: String
    var date: Date
    
    init(
        lastUpdated: String,
        identifier: String,
        name: String,
        date: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.name = name
        self.date = dateFormatter.date(from: date)!
    }
    
    func assert(against actual: Day) {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(date, actual.date)
    }
    
}
