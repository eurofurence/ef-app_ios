import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenNewsSceneDidLoad: XCTestCase {

    var context: NewsPresenterTestBuilder.Context!
    var newsViewModelFactory: FakeNewsViewModelProducer!

    override func setUp() {
        super.setUp()

        newsViewModelFactory = FakeNewsViewModelProducer()
        context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
    }

    func testTheNewsSceneIsToldToBindExpectedNumberOfComponentsFromViewModel() {
        let viewModel = newsViewModelFactory.lastCreatedViewModel
        XCTAssertEqual(viewModel.components.count, context.newsScene.capturedComponentsToBind)
    }

    func testTheNewsSceneIsToldToBindExpectedSubcomponentItemCountsFromViewModel() {
        let viewModel = newsViewModelFactory.lastCreatedViewModel
        let expected = viewModel.components.map(\.numberOfItems)

        XCTAssertEqual(expected, context.newsScene.capturedNumberOfItemsPerComponentToBind)
    }

    func testBindingTitleForSectionAppliesTitleFromViewModelOntoScene() {
        let viewModel = newsViewModelFactory.lastCreatedViewModel
        let component = viewModel.components.randomElement()
        let titleScene = CapturingNewsComponentHeaderScene()
        context.newsScene.capturedBinder?.bindTitleForSection(at: component.index, scene: titleScene)

        XCTAssertEqual(component.element.title, titleScene.capturedTitle)
    }

}
