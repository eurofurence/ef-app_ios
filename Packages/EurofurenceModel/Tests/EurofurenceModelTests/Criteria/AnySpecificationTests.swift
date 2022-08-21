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
    
    func testContains_Match() {
        let specification = AlwaysPassesSpecification<Int>().eraseToAnySpecification()
        XCTAssertTrue(specification.contains(AlwaysPassesSpecification<Int>.self))
    }
    
    func testContains_NoMatch() {
        let specification = AlwaysPassesSpecification<Int>().eraseToAnySpecification()
        XCTAssertFalse(specification.contains(AlwaysPassesSpecification<String>.self))
    }
    
    func testContains_Match_ViaAggregate() {
        let specification = AlwaysPassesSpecification<Int>()
            .and(AlwaysFailsSpecification<Int>())
            .eraseToAnySpecification()
        
        XCTAssertTrue(specification.contains(AlwaysFailsSpecification<Int>.self))
    }
    
    func testContains_NoMatch_ViaAggregate() {
        let specification = AlwaysPassesSpecification<Int>()
            .and(AlwaysFailsSpecification<Int>())
            .eraseToAnySpecification()
        
        XCTAssertFalse(specification.contains(AlwaysFailsSpecification<String>.self))
    }

}
