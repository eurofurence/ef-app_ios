import EurofurenceModel
import XCTest

class AnySpecificationTests: XCTestCase {

    func testErasesUnderlyingSpecificationExactly() {
        let specification = OnlyPassesOnSpecificInputSpecification(passesOn: "Hello, world")
        let erased = specification.eraseToAnySpecification()
        
        XCTAssertTrue(erased.isSatisfied(by: "Hello, world"))
        XCTAssertFalse(erased.isSatisfied(by: "Hello, you"))
    }
    
    func testEquality() {
        let first = OnlyPassesOnSpecificInputSpecification(passesOn: "Hello, world").eraseToAnySpecification()
        let second = OnlyPassesOnSpecificInputSpecification(passesOn: "Goodbye, world").eraseToAnySpecification()
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(second, second)
        XCTAssertNotEqual(first, second)
    }

}
