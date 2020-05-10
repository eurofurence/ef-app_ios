import XCTest

class WhenUserTapsShareButton_KnowledgeDetailPresenterShould: XCTestCase {

    func testTellTheViewModelToShareTheEvent() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        
        XCTAssertNil(context.viewModelFactory.viewModel.shareSender)
        
        let sender = self
        context.knowledgeDetailScene.simulateShareButtonTapped(sender)
        
        XCTAssertTrue(sender === context.viewModelFactory.viewModel.shareSender)
    }

}
