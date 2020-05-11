import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

struct StubSuperSponsorsOnlyEventViewModel: EventDetailViewModel {

    var superSponsorsOnlyWarningViewModel: EventSuperSponsorsOnlyWarningViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(superSponsorsOnlyWarningViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}

class WhenBindingSuperSponsorsOnlyMessage_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = FakeEvent.random
        let message = String.random
        let superSponsorsOnlyWarningViewModel = EventSuperSponsorsOnlyWarningViewModel(message: message)
        let viewModel = StubSuperSponsorsOnlyEventViewModel(superSponsorsOnlyWarningViewModel: superSponsorsOnlyWarningViewModel)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedSuperSponsorsOnlyComponent.capturedMessage)
    }

}
