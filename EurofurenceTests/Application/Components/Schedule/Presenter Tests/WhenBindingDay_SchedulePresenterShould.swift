@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDay_SchedulePresenterShould: XCTestCase {

    func testBindTheDayNameOntoTheComponent() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let randomDay = viewModel.days.randomElement()
        let component = CapturingScheduleDayComponent()
        context.bind(component, forDayAt: randomDay.index)

        XCTAssertEqual(randomDay.element.title, component.capturedTitle)
    }

}
