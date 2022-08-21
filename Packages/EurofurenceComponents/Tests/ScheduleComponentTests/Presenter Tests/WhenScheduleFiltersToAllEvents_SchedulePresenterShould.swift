import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class WhenScheduleFiltersToAllEvents_SchedulePresenterShould: XCTestCase {
    
    func testTellSceneToShowFavouritesFilterButton() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        viewModel.simulateShowingAllEvents()
        
        XCTAssertEqual(.filterToFavourites, context.scene.visibleFilterButton)
    }
    
}
