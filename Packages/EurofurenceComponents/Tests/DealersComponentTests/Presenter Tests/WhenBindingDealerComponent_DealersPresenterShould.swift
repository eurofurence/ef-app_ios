import DealersComponent
import EurofurenceModel
import XCTest

class WhenBindingDealerComponent_DealersPresenterShould: XCTestCase {

    func testBindTheDealerAttributesOntoTheComponent() throws {
        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let randomGroup = dealerGroups.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let dealer = try XCTUnwrap(randomDealer.element as? StubDealerViewModel)
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let component = CapturingDealerComponent()
        context.bind(component, toDealerAt: indexPath)
        
        XCTAssertEqual(dealer.title, component.capturedDealerTitle)
        XCTAssertEqual(dealer.subtitle, component.capturedDealerSubtitle)
        XCTAssertEqual(dealer.iconPNGData, component.capturedDealerPNGData)
    }

}
