import EurofurenceModel
import XCTest

class AndSpecificationTests: XCTestCase {
    
    func testMapsToAndTruthTable() {
        let alwaysPasses = AlwaysPassesSpecification<String>()
        let alwaysFails = AlwaysFailsSpecification<String>()
        
        XCTAssertTrue((alwaysPasses && alwaysPasses).isSatisfied(by: "Hello, world"))
        XCTAssertFalse((alwaysFails && alwaysFails).isSatisfied(by: "Hello, world"))
        XCTAssertFalse((alwaysPasses && alwaysFails).isSatisfied(by: "Hello, world"))
        XCTAssertFalse((alwaysFails && alwaysPasses).isSatisfied(by: "Hello, world"))
    }
    
}
