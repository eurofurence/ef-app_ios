import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class BeforeEventDetailSceneLoads_EventDetailPresenterShould: XCTestCase {

    func testNotApplyTheEventTitleFromTheViewModel() {
        let event = FakeEvent.random
        let summary = EventSummaryViewModel.random
        let viewModel = StubEventSummaryViewModel(summary: summary)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)

        XCTAssertNil(context.scene.stubbedEventSummaryComponent.capturedTitle)
    }

}
