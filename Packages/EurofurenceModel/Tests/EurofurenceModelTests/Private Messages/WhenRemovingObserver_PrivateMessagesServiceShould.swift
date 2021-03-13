import EurofurenceModel
import XCTest

class WhenRemovingObserver_PrivateMessagesServiceShould: XCTestCase {
    
    func testNotCallTheObserverAgain() {
        let context = EurofurenceSessionTestBuilder().loggedInWithValidCredential().build()
        let observer = CapturingPrivateMessagesObserver()
        context.privateMessagesService.add(observer)
        observer.wasToldSuccessfullyLoadedPrivateMessages = false
        context.privateMessagesService.removeObserver(observer)
        context.privateMessagesService.refreshMessages()
        context.api.simulateMessagesResponse()
        
        XCTAssertFalse(observer.wasToldSuccessfullyLoadedPrivateMessages)
    }

}
