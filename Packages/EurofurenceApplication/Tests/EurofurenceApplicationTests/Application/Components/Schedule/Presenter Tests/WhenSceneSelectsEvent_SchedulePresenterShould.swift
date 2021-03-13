import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsEvent_SchedulePresenterShould: XCTestCase {

    func testTellModuleEventWithResolvedIdentifierSelected() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let selectedIdentifier = EventIdentifier.random
        viewModel.stub(selectedIdentifier, at: indexPath)
        context.simulateSceneDidSelectEvent(at: indexPath)

        XCTAssertEqual(selectedIdentifier, context.delegate.capturedEventIdentifier)
    }

}
