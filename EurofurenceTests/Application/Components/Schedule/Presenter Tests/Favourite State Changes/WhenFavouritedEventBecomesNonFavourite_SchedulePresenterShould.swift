@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenFavouritedEventBecomesNonFavourite_SchedulePresenterShould: XCTestCase {

    func testTellTheComponentToHideTheFavouriteIndicator() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let scheduleViewModel = CapturingScheduleViewModel.random
        scheduleViewModel.events = [ScheduleEventGroupViewModel(title: "", events: [eventViewModel])]
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: scheduleViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
        eventViewModel.unfavourite()
        
        XCTAssertEqual(.hidden, component.favouriteIconVisibility)
    }

}
