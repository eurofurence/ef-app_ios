import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessageDetailPresenter2Tests: XCTestCase {
    
    func testLoadingMessage() {
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = CapturingPrivateMessagesService()
        let module = MessageDetail2ModuleBuilder().with(sceneFactory).with(messagesService).build()
        _ = module.makeMessageDetailModule(for: .random)
        
        XCTAssertEqual(.unset, sceneFactory.scene.loadingIndicatorVisibility)
        
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertEqual(.visible, sceneFactory.scene.loadingIndicatorVisibility)
    }
    
    func testMessageLoaded() {
        
    }
    
    func testMessageLoadFailure() {
        
    }
    
    func testRetryingAfterFailure() {
        
    }

}
