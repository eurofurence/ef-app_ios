@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelPrepared_EventDetailPresenterShould: XCTestCase {

    func testNotFavouriteTheViewModel() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()

        XCTAssertFalse(viewModel.wasToldToFavouriteEvent)
    }

    func testNotShowTheFavouriteEventButton() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()

        XCTAssertFalse(context.scene.didShowFavouriteEventButton)
    }

    func testNotUnfavouriteTheViewModel() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()

        XCTAssertFalse(viewModel.wasToldToUnfavouriteEvent)
    }

}
