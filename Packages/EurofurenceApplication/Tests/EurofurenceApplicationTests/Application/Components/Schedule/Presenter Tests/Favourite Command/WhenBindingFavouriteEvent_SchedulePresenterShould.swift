import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingFavouriteEvent_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertEqual(component.favouriteIconVisibility, .visible)
    }

    func testSupplyUnfavouriteAction() throws {
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
        let commands = context.scene.binder?.eventActionsForComponent(at: indexPath)
        
        let action = try XCTUnwrap(commands?.command(titled: .unfavourite))

        XCTAssertEqual("heart.slash.fill", action.sfSymbol)
        
        action.run(nil)

        XCTAssertFalse(eventViewModel.isFavourite, "Running the action should unfavourite the event")
    }

}
