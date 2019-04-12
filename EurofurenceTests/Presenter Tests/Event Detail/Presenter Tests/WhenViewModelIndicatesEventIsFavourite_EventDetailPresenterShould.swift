@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelIndicatesEventIsFavourite_EventDetailPresenterShould: XCTestCase {

    func testShowTheUnfavouriteEventButton() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.simulateFavourited()

        XCTAssertTrue(context.scene.didShowUnfavouriteEventButton)
    }

}
