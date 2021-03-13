import EurofurenceModel
import XCTest

class AnySpecificationTests: XCTestCase {

    func testErasesUnderlyingSpecificationExactly() {
        let specification = OnlyPassesOnSpecificInputSpecification(passesOn: "Hello, world")
        let erased = specification.eraseToAnySpecification()
        
        XCTAssertTrue(erased.isSatisfied(by: "Hello, world"))
        XCTAssertFalse(erased.isSatisfied(by: "Hello, you"))
    }

}
