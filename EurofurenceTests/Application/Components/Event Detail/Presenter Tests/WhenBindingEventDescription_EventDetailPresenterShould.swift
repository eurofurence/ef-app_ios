import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

class WhenBindingEventDescription_EventDetailPresenterShould: XCTestCase {

    func testBindTheEventDescription() {
        let event = FakeEvent.random
        let eventDescription = EventDescriptionViewModel.random
        let index = Int.random
        let viewModel = StubEventDescriptionViewModel(eventDescription: eventDescription, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
        
        XCTAssertEqual(eventDescription.contents, context.scene.stubbedEventDescriptionComponent.capturedEventDescription)
        XCTAssertTrue((boundComponent as? CapturingEventDescriptionComponent) === context.scene.stubbedEventDescriptionComponent)
    }

}
