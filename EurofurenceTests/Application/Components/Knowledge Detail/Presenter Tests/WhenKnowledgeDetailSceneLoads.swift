@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenKnowledgeDetailSceneLoads: XCTestCase {

    func testTheKnowledgeEntryFormattedTextIsAppliedOntoScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()

        XCTAssertEqual(context.viewModelFactory.viewModel.contents, context.knowledgeDetailScene.capturedKnowledgeAttributedText)
    }

    func testLinksFromTheKnowledgeEntryAreBoundOntoScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.viewModelFactory.viewModel.links.randomElement()
        let linkScene = CapturingLinkScene()
        context.knowledgeDetailScene.linksBinder?.bind(linkScene, at: randomLink.index)

        XCTAssertEqual(context.viewModelFactory.viewModel.links.count, context.knowledgeDetailScene.linksToPresent)
        XCTAssertEqual(randomLink.element.name, linkScene.capturedLinkName)
    }

    func testTheTitleFromTheViewModelIsBoundOntoTheScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let expected = context.viewModelFactory.viewModel.title

        XCTAssertEqual(expected, context.knowledgeDetailScene.capturedTitle)
    }

    func testBindTheImagesFromTheViewModelOntoTheScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomImage = context.viewModelFactory.viewModel.images.randomElement()
        let imageScene = CapturingKnowledgeEntryImageScene()
        context.knowledgeDetailScene.imagesBinder?.bind(imageScene, at: randomImage.index)

        XCTAssertEqual(context.viewModelFactory.viewModel.images.count, context.knowledgeDetailScene.boundImagesCount)
        XCTAssertEqual(randomImage.element.imagePNGData, imageScene.capturedImagePNGData)
    }

}
