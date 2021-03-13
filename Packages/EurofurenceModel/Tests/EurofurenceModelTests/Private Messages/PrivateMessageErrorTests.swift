import EurofurenceModel
import XCTest

class PrivateMessageErrorTests: XCTestCase {
    
    func testLoadingMessagesFailed() {
        assertLocalizedDescription(
            "Unable to load messages, please try again later",
            forError: .loadingMessagesFailed
        )
    }
    
    func testNoMessageFound() {
        assertLocalizedDescription(
            "Unable to find the specified message",
            forError: .noMessageFound
        )
    }
    
    private func assertLocalizedDescription(
        _ expected: String,
        forError error: PrivateMessageError,
        _ line: UInt = #line
    ) {
        XCTAssertEqual(expected, error.errorDescription, line: line)
    }

}
