@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelIndicatesEventIsFavourite_EventDetailPresenterShould: XCTestCase {

    func testPlaySelectionChangedHaptic() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.simulateFavourited()

        XCTAssertTrue(context.hapticEngine.played)
    }

}
