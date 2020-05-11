import Eurofurence
import EurofurenceModel
import XCTest

class WhenScheduleSceneLoads_SchedulePresenterShould: XCTestCase {

    func testBindNumberOfConferenceDaysOntoTheScene() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let expected = viewModel.days.count

        XCTAssertEqual(expected, context.scene.boundNumberOfDays)
    }

    func testBindNumberOfGroupsOntoScheduleScene() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let expected = viewModel.events.map(\.events.count)

        XCTAssertEqual(expected, context.scene.boundItemsPerSection)
    }

    func testTellTheSceneToSelectTheCurrentDayUsingIndexFromViewModel() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.currentDay, context.scene.selectedDayIndex)
    }

}
