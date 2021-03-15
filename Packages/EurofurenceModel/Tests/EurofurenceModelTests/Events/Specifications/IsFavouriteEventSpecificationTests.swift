import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class IsFavouriteEventSpecificationTests: XCTestCase {
    
    func testIsSatisfiedByFavouriteEvent() {
        let event = FakeEvent.random
        event.isFavourite = true
        let specification = IsFavouriteEventSpecification()
        
        XCTAssertTrue(specification.isSatisfied(by: event))
    }
    
    func testIsNotSatisfiedByFavouriteEvent() {
        let event = FakeEvent.random
        event.isFavourite = false
        let specification = IsFavouriteEventSpecification()
        
        XCTAssertFalse(specification.isSatisfied(by: event))
    }

}
