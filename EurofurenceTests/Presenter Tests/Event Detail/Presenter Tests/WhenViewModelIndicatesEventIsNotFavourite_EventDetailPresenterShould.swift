@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelIndicatesEventIsNotFavourite_EventDetailPresenterShould: XCTestCase {

    func testShowTheFavouriteEventButton() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.simulateUnfavourited()

        XCTAssertTrue(context.scene.didShowFavouriteEventButton)
    }

}
