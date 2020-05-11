import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingEventBanner_EventDetailPresenterShould: XCTestCase {

    func testApplyTheBannerGraphicDataOntoTheScene() {
        let event = FakeEvent.random
        let graphic = EventGraphicViewModel.random
        let index = Int.random
        let viewModel = StubEventGraphicViewModel(graphic: graphic, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        _ = context.scene.bindComponent(at: IndexPath(item: index, section: 0))

        XCTAssertEqual(graphic.pngGraphicData, context.scene.stubbedEventGraphicComponent.capturedPNGGraphicData)
    }

    func testReturnTheBoundGraphicComponent() {
        let event = FakeEvent.random
        let graphic = EventGraphicViewModel.random
        let index = Int.random
        let viewModel = StubEventGraphicViewModel(graphic: graphic, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))

        XCTAssertTrue((boundComponent as? CapturingEventGraphicComponent) === context.scene.stubbedEventGraphicComponent)
    }

}
