import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelPrepared_EventDetailPresenterShould: XCTestCase {

    func testNotChangeTheFavouriteState() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()

        XCTAssertFalse(viewModel.wasToldToFavouriteEvent)
        XCTAssertFalse(viewModel.wasToldToUnfavouriteEvent)
    }

}
