@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingEventFromSearchResult_SchedulePresenterShould: XCTestCase {

    func testBindTheEventAttributesOntoTheComponent() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel].random
        searchViewModel.simulateSearchResultsUpdated(results)
        let randomGroup = results.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let eventViewModel = randomEvent.element
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)

        XCTAssertEqual(eventViewModel.title, component.capturedEventTitle)
        XCTAssertEqual(eventViewModel.startTime, component.capturedStartTime)
        XCTAssertEqual(eventViewModel.endTime, component.capturedEndTime)
        XCTAssertEqual(eventViewModel.location, component.capturedLocation)
    }

}
