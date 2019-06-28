@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningMessage_DirectorShould: XCTestCase {

    func testPushMessageDetailModuleOntoNewsNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let newsNavigationController = context.navigationController(for: context.newsModule.stubInterface)
        let message = MessageIdentifier.random
        context.director.openMessage(message)
        
        XCTAssertEqual(context.messageDetailModule.stubInterface, newsNavigationController?.topViewController)
        XCTAssertEqual(message, context.messageDetailModule.capturedMessage)
    }

}
