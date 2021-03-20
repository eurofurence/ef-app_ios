import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTScheduleComponent

class WhenBindingEvent_SchedulePresenterShould: XCTestCase {

    var context: SchedulePresenterTestBuilder.Context!
    var component: CapturingScheduleEventComponent!
    var eventViewModel: ScheduleEventViewModelProtocol!

    override func setUp() {
        super.setUp()

        let viewModel = CapturingScheduleViewModel.random
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        eventViewModel = randomEvent.element
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
    }

    func testBindTheEventAttributesOntoTheComponent() {
        XCTAssertEqual(eventViewModel.title, component.capturedEventTitle)
        XCTAssertEqual(eventViewModel.startTime, component.capturedStartTime)
        XCTAssertEqual(eventViewModel.endTime, component.capturedEndTime)
        XCTAssertEqual(eventViewModel.location, component.capturedLocation)
        XCTAssertEqual(eventViewModel.bannerGraphicPNGData, component.capturedBannerGraphicPNGData)
    }

    func testShowTheBanner() {
        XCTAssertTrue(component.didShowBanner)
        XCTAssertFalse(component.didHideBanner)
    }

}
