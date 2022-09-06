import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Message {
    
    func assert(against actual: EurofurenceKit.Message) {
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(author, actual.author)
        XCTAssertEqual(subject, actual.subject)
        XCTAssertEqual(message, actual.message)
        XCTAssertEqual(receivedDate, actual.receivedDate)
        XCTAssertEqual(readDate, actual.readDate)
    }
    
}
