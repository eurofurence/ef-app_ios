import DealerComponent
import DealersJourney
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class ShowDealerFromDealersTests: XCTestCase {
    
    func testShowingDealer() {
        let router = FakeContentRouter()
        let navigator = ShowDealerFromDealers(router: router)
        let dealer = DealerIdentifier.random
        navigator.dealersModuleDidSelectDealer(identifier: dealer)
        
        router.assertRouted(to: DealerContentRepresentation(identifier: dealer))
    }

}
