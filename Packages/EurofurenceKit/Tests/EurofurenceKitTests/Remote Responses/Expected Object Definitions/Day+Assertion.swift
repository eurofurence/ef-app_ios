@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Day {
    
    func assert(against actual: EurofurenceKit.Day) {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(date, actual.date)
    }
    
}
