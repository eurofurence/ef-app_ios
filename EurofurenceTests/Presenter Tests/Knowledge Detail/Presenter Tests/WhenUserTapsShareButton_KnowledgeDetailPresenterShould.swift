import XCTest

class WhenUserTapsShareButton_KnowledgeDetailPresenterShould: XCTestCase {

    func testTellTheViewModelToShareTheEvent() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        
        XCTAssertNil(context.interactor.viewModel.shareSender)
        
        let sender = self
        context.knowledgeDetailScene.simulateShareButtonTapped(sender)
        
        XCTAssertTrue(sender === context.interactor.viewModel.shareSender)
    }

}
