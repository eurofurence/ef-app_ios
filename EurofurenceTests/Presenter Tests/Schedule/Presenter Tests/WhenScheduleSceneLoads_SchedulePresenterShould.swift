@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenScheduleSceneLoads_SchedulePresenterShould: XCTestCase {

    func testBindNumberOfConferenceDaysOntoTheScene() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = viewModel.days.count

        XCTAssertEqual(expected, context.scene.boundNumberOfDays)
    }

    func testBindNumberOfGroupsOntoScheduleScene() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = viewModel.events.map({ $0.events.count })

        XCTAssertEqual(expected, context.scene.boundItemsPerSection)
    }

    func testTellTheSceneToSelectTheCurrentDayUsingIndexFromViewModel() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.currentDay, context.scene.selectedDayIndex)
    }

}
