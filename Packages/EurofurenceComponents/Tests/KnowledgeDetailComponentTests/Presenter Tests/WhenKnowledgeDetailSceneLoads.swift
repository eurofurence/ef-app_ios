import EurofurenceModel
import KnowledgeDetailComponent
import XCTest

class WhenKnowledgeDetailSceneLoads: XCTestCase {
    
    var context: KnowledgeDetailPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
    }

    func testTheKnowledgeEntryisBoundToTheScene() {
        let viewModel = context.viewModelFactory.viewModel
        
        XCTAssertEqual(viewModel.title, context.knowledgeDetailScene.capturedTitle)
        XCTAssertEqual(viewModel.contents, context.knowledgeDetailScene.capturedKnowledgeAttributedText)
    }

    func testLinksAreBoundOntoScene() {
        let randomLink = context.viewModelFactory.viewModel.links.randomElement()
        let linkScene = CapturingLinkScene()
        context.knowledgeDetailScene.linksBinder?.bind(linkScene, at: randomLink.index)

        XCTAssertEqual(context.viewModelFactory.viewModel.links.count, context.knowledgeDetailScene.linksToPresent)
        XCTAssertEqual(randomLink.element.name, linkScene.capturedLinkName)
    }

    func testImagesAreBoundOntoTheScene() {
        let randomImage = context.viewModelFactory.viewModel.images.randomElement()
        let imageScene = CapturingKnowledgeEntryImageScene()
        context.knowledgeDetailScene.imagesBinder?.bind(imageScene, at: randomImage.index)

        XCTAssertEqual(context.viewModelFactory.viewModel.images.count, context.knowledgeDetailScene.boundImagesCount)
        XCTAssertEqual(randomImage.element.imagePNGData, imageScene.capturedImagePNGData)
    }

}
