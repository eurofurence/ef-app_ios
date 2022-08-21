import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class WhenSceneTogglesFavouriteFilteringState_SchedulePresenterShould: XCTestCase {
    
    func testTellViewModelToToggleActiveFavouritesFilteringState() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidToggleFavouriteFilterState()
        
        XCTAssertTrue(viewModel.didToggleFavouriteFilteringState)
    }
    
}
