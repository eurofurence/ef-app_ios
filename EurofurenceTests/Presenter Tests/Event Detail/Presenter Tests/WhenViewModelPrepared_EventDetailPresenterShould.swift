@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelPrepared_EventDetailPresenterShould: XCTestCase {

    func testNotFavouriteTheViewModel() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()

        XCTAssertFalse(viewModel.wasToldToFavouriteEvent)
    }

    func testNotUnfavouriteTheViewModel() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()

        XCTAssertFalse(viewModel.wasToldToUnfavouriteEvent)
    }

}
