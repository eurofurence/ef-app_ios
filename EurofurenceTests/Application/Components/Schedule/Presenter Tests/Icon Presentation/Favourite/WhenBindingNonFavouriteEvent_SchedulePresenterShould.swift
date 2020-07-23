import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingNonFavouriteEvent_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToHideTheFavouriteEventIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.favouriteIconVisibility, .hidden)
    }

    func testSupplyFavouriteAction() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionsForComponent(at: indexPath).first

        XCTAssertEqual(.favourite, action?.title)
        XCTAssertEqual("heart.fill", action?.sfSymbol)
        
        action?.run(nil)

        XCTAssertTrue(eventViewModel.isFavourite, "Running the action should favourite the event")
    }

}
