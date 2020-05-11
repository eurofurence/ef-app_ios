import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

class WhenBindingEventDescription_EventDetailPresenterShould: XCTestCase {

    var context: EventDetailPresenterTestBuilder.Context!
    var eventDescription: EventDescriptionViewModel!
    var boundComponent: Any?

    override func setUp() {
        super.setUp()

        let event = FakeEvent.random
        eventDescription = .random
        let index = Int.random
        let viewModel = StubEventDescriptionViewModel(eventDescription: eventDescription, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
    }

    func testApplyTheEventDescriptionOntoTheScene() {
        XCTAssertEqual(eventDescription.contents, context.scene.stubbedEventDescriptionComponent.capturedEventDescription)
    }

    func testReturnTheDescriptionComponent() {
        XCTAssertTrue((boundComponent as? CapturingEventDescriptionComponent) === context.scene.stubbedEventDescriptionComponent)
    }

}
