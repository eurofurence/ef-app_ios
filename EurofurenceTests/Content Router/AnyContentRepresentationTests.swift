import Eurofurence
import XCTest

class AnyContentRepresentationTests: XCTestCase {
    
    func testErasure() throws {
        let representation = SomeContentRepresentation(value: 42)
        let anyRepresentation = representation.eraseToAnyContentRepresentation()
        let recipient = CapturingContentRepresentationRecipient()
        anyRepresentation.describe(to: recipient)
        
        let unwrapped = try XCTUnwrap(recipient.receivedContent as? SomeContentRepresentation<Int>)
        
        XCTAssertEqual(representation, unwrapped)
    }
    
    func testEquality() {
        let first = SomeContentRepresentation(value: 108).eraseToAnyContentRepresentation()
        let second = SomeContentRepresentation(value: "Hello, World").eraseToAnyContentRepresentation()
        
        XCTAssertEqual(first, first)
        XCTAssertNotEqual(first, second)
        XCTAssertEqual(second, second)
    }
    
    private struct SomeContentRepresentation<T>: ContentRepresentation where T: Equatable {
        
        var value: T
        
    }

}
