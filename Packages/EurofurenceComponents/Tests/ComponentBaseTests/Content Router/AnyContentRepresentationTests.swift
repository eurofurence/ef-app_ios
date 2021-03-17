import ComponentBase
import XCTComponentBase
import XCTest

class AnyContentRepresentationTests: ContentRepresentationTestCase {
    
    func testErasure() {
        let representation = SomeContentRepresentation(value: 42)

        assert(
            content: representation.eraseToAnyContentRepresentation(),
            isDescribedAs: representation
        )
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
