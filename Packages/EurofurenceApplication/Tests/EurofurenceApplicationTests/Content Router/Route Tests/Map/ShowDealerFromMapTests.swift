import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTRouter

class ShowDealerFromMapTests: XCTestCase {
    
    func testShowsDealer() {
        let router = FakeContentRouter()
        let route = ShowDealerFromMap(router: router)
        let dealer = DealerIdentifier.random
        route.mapDetailModuleDidSelectDealer(dealer)
        
        router.assertRouted(to: EmbeddedDealerRouteable(identifier: dealer))
    }

}
