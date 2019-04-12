@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneTapsFavouriteEventButton_EventDetailPresenterShould: XCTestCase {

    func testInvokeTheFavouriteActionOnTheViewModel() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.simulateFavouriteEventButtonTapped()

        XCTAssertTrue(viewModel.wasToldToFavouriteEvent)
    }

    func testPlaySelectionHaptic() {
        let context = EventDetailPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateFavouriteEventButtonTapped()

        XCTAssertTrue(context.hapticEngine.didPlaySelectionHaptic)
    }

}
