import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingEventGroup_SchedulePresenterShould: XCTestCase {

    func testBindTheGroupTitleOntoTheHeader() {
        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let header = CapturingScheduleEventGroupHeader()
        context.bind(header, forGroupAt: randomGroup.index)

        XCTAssertEqual(randomGroup.element.title, header.capturedTitle)
    }

}
