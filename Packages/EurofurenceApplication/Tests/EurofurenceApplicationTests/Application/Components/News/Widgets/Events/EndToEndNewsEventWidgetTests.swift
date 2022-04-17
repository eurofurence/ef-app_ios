import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class EndToEndNewsEventWidgetTests: XCTestCase {
    
    func testSelectingEventNotifiesDelegate() throws {
        let event = FakeEvent.random
        let schedule = FakeScheduleRepository()
        schedule.allEvents = [event]
        
        let specification = AlwaysPassesSpecification<Event>()
        let dataSource = FilteredScheduleWidgetDataSource(repository: schedule, specification: specification)
        let viewModelFactory = EventsWidgetViewModelFactory(dataSource: dataSource, description: "Test")
        
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let widget = MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: TableViewNewsWidgetViewFactory())
        
        let componentFactory = CompositionalNewsComponentBuilder().with(sceneFactory).with(widget).build()
        let delegate = CapturingNewsComponentDelegate()
        _ = componentFactory.makeNewsComponent(delegate)
        sceneFactory.scene.simulateSceneReady()
        
        let eventsDataSource = try XCTUnwrap(sceneFactory.scene.installedDataSources.first)
        eventsDataSource.tableView?(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(event.identifier, delegate.capturedEvent)
    }
    
    private struct AlwaysPassesSpecification<T>: Specification {
        
        func isSatisfied(by element: T) -> Bool {
            true
        }
        
    }
    
}
