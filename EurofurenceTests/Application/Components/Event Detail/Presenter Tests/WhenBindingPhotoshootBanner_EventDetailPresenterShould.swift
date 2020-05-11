import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

struct StubPhotoshootEventViewModel: EventDetailViewModel {

    var photoshootMessageViewModel: EventPhotoshootMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(photoshootMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}

class WhenBindingPhotoshootBanner_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = FakeEvent.random
        let message = String.random
        let kageMessageViewModel = EventPhotoshootMessageViewModel(message: message)
        let viewModel = StubPhotoshootEventViewModel(photoshootMessageViewModel: kageMessageViewModel)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedPhotoshootMessageComponent.capturedMessage)
    }

}
