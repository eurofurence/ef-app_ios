@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenToldToLeaveFeedback_EventDetailPresenterShould: XCTestCase {

    func testTellTheDelegateToOpenFeedback() {
        let viewModel = CapturingEventDetailViewModel()
        let event = FakeEvent.random
        let interactor = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.delegate?.leaveFeedback()
        
        XCTAssertEqual(event.identifier, context.delegate.eventToldToLeaveFeedbackFor)
    }

}
