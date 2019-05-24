@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenUserSelectsKnowledgeLink: XCTestCase {
    
    func testTheDelegateIsToldToOpenTheChosenLink() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.interactor.viewModel.modelLinks.randomElement()
        let expected = context.interactor.viewModel.link(at: randomLink.index)
        let linkScene = CapturingLinkScene()
        context.knowledgeDetailScene.linksBinder?.bind(linkScene, at: randomLink.index)
        linkScene.simulateTapped()
        
        XCTAssertEqual(expected.name, context.delegate.capturedLinkToOpen?.name)
    }

    func testTheDelegateIsToldToOpenTheChosenLink_OLD() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.interactor.viewModel.modelLinks.randomElement()
        let expected = context.interactor.viewModel.link(at: randomLink.index)
        context.knowledgeDetailScene.simulateSelectingLink(at: randomLink.index)

        XCTAssertEqual(expected.name, context.delegate.capturedLinkToOpen?.name)
    }

}
