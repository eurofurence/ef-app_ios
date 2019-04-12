@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealersModuleSelectsDealer_DirectorShould: XCTestCase {

    func testPushDealerDetailModuleOntoDealersNavigationControllerForSelectedDealer() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let dealersNavigationController = context.navigationController(for: context.dealersModule.stubInterface)
        let dealer = DealerIdentifier.random
        context.dealersModule.simulateDidSelectDealer(dealer)

        XCTAssertEqual(context.dealerDetailModule.stubInterface, dealersNavigationController?.topViewController)
        XCTAssertEqual(dealer, context.dealerDetailModule.capturedModel)
    }

}
