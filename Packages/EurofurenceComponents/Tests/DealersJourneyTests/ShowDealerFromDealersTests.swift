import DealerComponent
import DealersJourney
import EurofurenceModel
import XCTest
import XCTEurofurenceModel
import XCTRouter

class ShowDealerFromDealersTests: XCTestCase {
    
    func testShowingDealer() {
        let router = FakeContentRouter()
        let navigator = ShowDealerFromDealers(router: router)
        let dealer = DealerIdentifier.random
        navigator.dealersModuleDidSelectDealer(identifier: dealer)
        
        router.assertRouted(to: DealerRouteable(identifier: dealer))
    }

}
