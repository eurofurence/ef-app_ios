import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingSponsorsOnlyMessage_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = FakeEvent.random
        let message = String.random
        let sponsorsOnlyViewModel = EventSponsorsOnlyWarningViewModel(message: message)
        let viewModel = StubSponsorsOnlyEventViewModel(sponsorsOnlyWarningViewModel: sponsorsOnlyViewModel)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedSponsorsOnlyComponent.capturedMessage)
    }

}
