@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenNewsSceneDidLoad: XCTestCase {

    var context: NewsPresenterTestBuilder.Context!
    var newsInteractor: FakeNewsViewModelProducer!

    override func setUp() {
        super.setUp()

        newsInteractor = FakeNewsViewModelProducer()
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
    }

    func testTheNewsSceneIsToldToBindExpectedNumberOfComponentsFromViewModel() {
        let viewModel = newsInteractor.lastCreatedViewModel
        XCTAssertEqual(viewModel.components.count, context.newsScene.capturedComponentsToBind)
    }

    func testTheNewsSceneIsToldToBindExpectedSubcomponentItemCountsFromViewModel() {
        let viewModel = newsInteractor.lastCreatedViewModel
        let expected = viewModel.components.map(\.numberOfItems)

        XCTAssertEqual(expected, context.newsScene.capturedNumberOfItemsPerComponentToBind)
    }

    func testBindingTitleForSectionAppliesTitleFromViewModelOntoScene() {
        let viewModel = newsInteractor.lastCreatedViewModel
        let component = viewModel.components.randomElement()
        let titleScene = CapturingNewsComponentHeaderScene()
        context.newsScene.capturedBinder?.bindTitleForSection(at: component.index, scene: titleScene)

        XCTAssertEqual(component.element.title, titleScene.capturedTitle)
    }

}
