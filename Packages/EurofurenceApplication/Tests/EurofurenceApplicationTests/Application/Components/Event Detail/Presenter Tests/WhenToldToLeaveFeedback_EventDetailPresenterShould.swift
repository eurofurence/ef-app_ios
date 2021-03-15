import EurofurenceApplication
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToLeaveFeedback_EventDetailPresenterShould: XCTestCase {

    func testTellTheDelegateToOpenFeedback() {
        let viewModel = CapturingEventDetailViewModel()
        let event = FakeEvent.random
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.delegate?.leaveFeedback()
        
        XCTAssertEqual(event.identifier, context.delegate.eventToldToLeaveFeedbackFor)
    }

}
