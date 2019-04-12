@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsUnfavouriteEventButton_EventDetailPresenterShould: XCTestCase {

    func testInvokeTheUnfavouriteActionOnTheViewModel() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.simulateUnfavouriteEventButtonTapped()

        XCTAssertTrue(viewModel.wasToldToUnfavouriteEvent)
    }

    func testPlaySelectionHaptic() {
        let context = EventDetailPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateUnfavouriteEventButtonTapped()

        XCTAssertTrue(context.hapticEngine.didPlaySelectionHaptic)
    }

}
