import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingEventSummary_EventDetailPresenterShould: XCTestCase {

    func testBindTheSummaryComponent() {
        let event = FakeEvent.random
        let summary = EventSummaryViewModel.random
        let index = Int.random
        let viewModel = StubEventSummaryViewModel(summary: summary, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
        let eventSummaryComponent = context.scene.stubbedEventSummaryComponent
        
        XCTAssertEqual(viewModel.numberOfComponents, context.scene.numberOfBoundsComponents)
        XCTAssertTrue((boundComponent as? CapturingEventSummaryComponent) === eventSummaryComponent)
        XCTAssertEqual(summary.title, eventSummaryComponent.capturedTitle)
        XCTAssertEqual(summary.subtitle, eventSummaryComponent.capturedSubtitle)
        XCTAssertEqual(summary.abstract, eventSummaryComponent.capturedAbstract)
        XCTAssertEqual(summary.eventStartEndTime, eventSummaryComponent.capturedEventStartTime)
        XCTAssertEqual(summary.location, eventSummaryComponent.capturedEventLocation)
        XCTAssertEqual(summary.trackName, eventSummaryComponent.capturedTrackName)
        XCTAssertEqual(summary.eventHosts, eventSummaryComponent.capturedEventHosts)
    }

}
