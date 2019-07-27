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
        
        XCTAssertEqual(3, newsNavigationController?.viewControllers.count)
        XCTAssertTrue(newsNavigationController?.viewControllers[0] === context.newsModule.stubInterface)
        XCTAssertTrue(newsNavigationController?.viewControllers[1] === context.messages.stubInterface)
        XCTAssertTrue(newsNavigationController?.viewControllers[2] === context.messageDetailModule.stubInterface)
        XCTAssertEqual(message, context.messageDetailModule.capturedMessage)
    }

}
