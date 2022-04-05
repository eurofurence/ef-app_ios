import Combine
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class FilteredScheduleWidgetDataSourceTests: XCTestCase {
    
    func testFiltersEventsToSpecification() throws {
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
    
    func testCorrectlyRetainsScheduleForFutureUpdates_BUG() {
        let event = FakeEvent.random
        var dataSource: FilteredScheduleWidgetDataSource<FilterSpecificEventSpecification>!
        weak var weakSchedule: FakeEventsSchedule?
        
        autoreleasepool {
            let specification = FilterSpecificEventSpecification(satisactoryEvent: event)
            let repository = FakeScheduleRepository()
            dataSource = FilteredScheduleWidgetDataSource(repository: repository, specification: specification)
            weakSchedule = repository.lastProducedSchedule
        }
        
        weakSchedule?.simulateEventsChanged([event])
        
        var actual = [Event]()
        let cancellable = dataSource
            .events
            .sink { (events) in
                actual = events
            }
        
        let expected: [Event] = [event]
        let elementsEqual = expected.elementsEqual(actual, by: { $0.identifier == $1.identifier })
        
        XCTAssertTrue(elementsEqual, "Data source should retain schedule for future updates")
        
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
