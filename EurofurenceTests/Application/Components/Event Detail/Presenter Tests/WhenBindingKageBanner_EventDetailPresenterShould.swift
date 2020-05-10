@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

struct StubKageEventViewModel: EventDetailViewModel {

    var kageMessageViewModel: EventKageMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(kageMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}

class WhenBindingKageBanner_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = FakeEvent.random
        let message = String.random
        let kageMessageViewModel = EventKageMessageViewModel(message: message)
        let viewModel = StubKageEventViewModel(kageMessageViewModel: kageMessageViewModel)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedKageMessageComponent.capturedMessage)
    }

}