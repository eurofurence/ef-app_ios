import EurofurenceModel
import KnowledgeDetailComponent
import XCTest

class WhenUserSelectsKnowledgeLink: XCTestCase {
    
    func testTheDelegateIsToldToOpenTheChosenLink() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.viewModelFactory.viewModel.modelLinks.randomElement()
        let expected = context.viewModelFactory.viewModel.link(at: randomLink.index)
        let linkScene = CapturingLinkScene()
        context.knowledgeDetailScene.linksBinder?.bind(linkScene, at: randomLink.index)
        linkScene.simulateTapped()
        
        XCTAssertEqual(expected.name, context.delegate.capturedLinkToOpen?.name)
    }

}
