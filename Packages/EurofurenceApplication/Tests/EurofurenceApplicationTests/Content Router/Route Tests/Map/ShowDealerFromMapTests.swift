import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest

class ShowDealerFromMapTests: XCTestCase {
    
    func testShowsDealer() {
        let router = FakeContentRouter()
        let route = ShowDealerFromMap(router: router)
        let dealer = DealerIdentifier.random
        route.mapDetailModuleDidSelectDealer(dealer)
        
        router.assertRouted(to: EmbeddedDealerContentRepresentation(identifier: dealer))
    }

}
