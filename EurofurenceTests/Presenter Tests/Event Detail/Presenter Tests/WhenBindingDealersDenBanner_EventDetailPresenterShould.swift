@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

struct StubDealersDenEventViewModel: EventDetailViewModel {

    var dealersDenMessageViewModel: EventDealersDenMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(dealersDenMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}

class WhenBindingDealersDenBanner_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = FakeEvent.random
        let message = String.random
        let artShowViewModel = EventDealersDenMessageViewModel(message: message)
        let viewModel = StubDealersDenEventViewModel(dealersDenMessageViewModel: artShowViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedDealersDenMessageComponent.capturedMessage)
    }

}
