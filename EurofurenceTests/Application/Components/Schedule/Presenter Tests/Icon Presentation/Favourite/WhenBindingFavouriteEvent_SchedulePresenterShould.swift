import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingFavouriteEvent_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.favouriteIconVisibility, .visible)
    }

    func testSupplyUnfavouriteActionInformation() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionsForComponent(at: indexPath).first

        XCTAssertEqual(.unfavourite, action?.title)
        XCTAssertEqual("heart.slash.fill", action?.sfSymbol)
    }

    func testTellViewModelToUnfavouriteEventWhenInvokingAction() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionsForComponent(at: indexPath).first
        action?.run()

        XCTAssertFalse(eventViewModel.isFavourite, "Running the action should unfavourite the event")
    }

}
