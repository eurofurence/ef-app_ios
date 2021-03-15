import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenMessagesSceneFinalizes_MessagesPresenterShould: XCTestCase {

    func testRemoveItselfAsAnObserverFromTheModel() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneReady()
        context.scene.delegate?.messagesSceneFinalizing()
        
        XCTAssertNotNil(context.privateMessagesService.removedObserver)
    }

}
