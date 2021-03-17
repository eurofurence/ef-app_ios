import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTComponentBase
import XCTest

class ShowDealerFromDealersTests: XCTestCase {
    
    func testShowingDealer() {
        let router = FakeContentRouter()
        let navigator = ShowDealerFromDealers(router: router)
        let dealer = DealerIdentifier.random
        navigator.dealersModuleDidSelectDealer(identifier: dealer)
        
        router.assertRouted(to: DealerContentRepresentation(identifier: dealer))
    }

}
