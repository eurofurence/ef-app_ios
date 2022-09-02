@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Room {
    
    func assert(against actual: EurofurenceKit.Room) {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(shortName, actual.shortName)
    }
    
}
