import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenNonFavouritedEventBecomesFavourited_SchedulePresenterShould: XCTestCase {

    func testTellTheComponentToShowTheFavouriteIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let scheduleViewModel = CapturingScheduleViewModel.random
        scheduleViewModel.events = [ScheduleEventGroupViewModel(title: "", events: [eventViewModel])]
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: scheduleViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
        eventViewModel.favourite()
        
        XCTAssertEqual(.visible, component.favouriteIconVisibility)
    }

}
