import EurofurenceModel
import XCTest

class AndSpecificationTests: XCTestCase {
    
    func testMapsToAndTruthTable() {
        let alwaysPasses = AlwaysPassesSpecification<String>()
        let alwaysFails = AlwaysFailsSpecification<String>()
        
        XCTAssertTrue(alwaysPasses.and(alwaysPasses).isSatisfied(by: "Hello, world"))
        XCTAssertFalse(alwaysFails.and(alwaysFails).isSatisfied(by: "Hello, world"))
        XCTAssertFalse(alwaysPasses.and(alwaysFails).isSatisfied(by: "Hello, world"))
        XCTAssertFalse(alwaysFails.and(alwaysPasses).isSatisfied(by: "Hello, world"))
    }
    
}
