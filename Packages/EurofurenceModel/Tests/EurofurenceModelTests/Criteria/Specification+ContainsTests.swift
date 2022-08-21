import EurofurenceModel
import XCTest

class Specification_ContainsTests: XCTestCase {
    
    func testSpecificationIsCandidate() {
        let specification = AlwaysPassesSpecification<Int>()
        XCTAssertTrue(specification.contains(AlwaysPassesSpecification<Int>.self))
    }
    
    func testSpecificationIsNotCandidate() {
        let specification = AlwaysPassesSpecification<Int>()
        XCTAssertFalse(specification.contains(AlwaysPassesSpecification<Bool>.self))
    }
    
    func testSpecificationIsComposite_ContainsCandidate() {
        let composite = AlwaysFailsSpecification<Int>().and(AlwaysPassesSpecification<Int>())
        XCTAssertTrue(composite.contains(AlwaysPassesSpecification<Int>.self))
    }
    
    func testSpecificationIsComposide_DoesNotContainCandidate() {
        let composite = AlwaysFailsSpecification<Int>().and(AlwaysPassesSpecification<Int>())
        XCTAssertFalse(composite.contains(AlwaysPassesSpecification<Bool>.self))
    }
    
}
