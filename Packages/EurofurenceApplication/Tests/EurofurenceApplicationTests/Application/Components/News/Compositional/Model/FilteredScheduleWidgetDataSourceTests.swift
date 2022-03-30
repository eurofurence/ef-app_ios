import Combine
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class FilteredScheduleWidgetDataSourceTests: XCTestCase {
    
    func testUsesUpcomingEventsSpecification() throws {
        let (first, second, third) = (FakeEvent.random, FakeEvent.random, FakeEvent.random)
        let specification = FilterSpecificEventSpecification(satisactoryEvent: second)
        let repository = FakeScheduleRepository()
        repository.allEvents = [first, second, third]
        let dataSource = FilteredScheduleWidgetDataSource(repository: repository, specification: specification)
        
        var actual = [Event]()
        let cancellable = dataSource
            .events
            .sink { (events) in
                actual = events
            }
        
        let expected: [Event] = [second]
        let elementsEqual = expected.elementsEqual(actual, by: { $0.identifier == $1.identifier })
        
        XCTAssertTrue(elementsEqual, "Data source should be using the output of the filtered schedule")
        
        cancellable.cancel()
    }
    
    private struct FilterSpecificEventSpecification: Specification {
        
        static func == (lhs: FilterSpecificEventSpecification, rhs: FilterSpecificEventSpecification) -> Bool {
            lhs.satisactoryEvent.identifier == rhs.satisactoryEvent.identifier
        }
        
        typealias Element = Event
        
        var satisactoryEvent: Event
        
        func isSatisfied(by element: Element) -> Bool {
            element.identifier == satisactoryEvent.identifier
        }
        
    }
    
}
