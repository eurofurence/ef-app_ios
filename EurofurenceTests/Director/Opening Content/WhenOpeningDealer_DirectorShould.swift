@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningDealer_DirectorShould: XCTestCase {
    
    func testPushDealerDetailModuleOntoDealersNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let dealersNavigationController = context.navigationController(for: context.dealersModule.stubInterface)
        let dealer = DealerIdentifier.random
        context.director.openDealer(dealer)
        
        XCTAssertEqual(context.dealerDetailModule.stubInterface, dealersNavigationController?.topViewController)
        XCTAssertEqual(dealer, context.dealerDetailModule.capturedModel)
    }
    
}
