import DealersComponent
import EurofurenceModel
import XCTest

class WhenBindingDealerSearchResult_DealersPresenterShould: XCTestCase {

    func testBindTheDealerAttributesOntoTheComponent() throws {
        let dealerGroups = [DealersGroupViewModel].random
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: dealerGroups)
        let viewModelFactory = FakeDealersViewModelFactory(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let randomGroup = dealerGroups.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let dealer = try XCTUnwrap(randomDealer.element as? StubDealerViewModel)
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let component = CapturingDealerComponent()
        context.bind(component, toDealerSearchResultAt: indexPath)
        
        XCTAssertEqual(dealer.title, component.capturedDealerTitle)
        XCTAssertEqual(dealer.subtitle, component.capturedDealerSubtitle)
        XCTAssertEqual(dealer.iconPNGData, component.capturedDealerPNGData)
    }

}
