import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingEvent_WithNoPoster_SchedulePresenterShould: XCTestCase {

    func testNotShowTheBanner() {
        let viewModel = CapturingScheduleViewModel.random
        let group = viewModel.events.randomElement()
        let event = group.element.events.randomElement()
        let stubbedEventViewModel = viewModel.eventViewModel(inGroup: group.index, at: event.index)
        stubbedEventViewModel.bannerGraphicPNGData = nil

        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: event.index, section: group.index)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)

        XCTAssertFalse(component.didShowBanner)
        XCTAssertTrue(component.didHideBanner)
    }

}
