import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class WhenScheduleFiltersToFavourites_SchedulePresenterShould: XCTestCase {
    
    func testTellSceneToShowAllEventsFilterButton() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        viewModel.simulateShowingFavourites()
        
        XCTAssertEqual(.filterToAllEvents, context.scene.visibleFilterButton)
    }
    
}
