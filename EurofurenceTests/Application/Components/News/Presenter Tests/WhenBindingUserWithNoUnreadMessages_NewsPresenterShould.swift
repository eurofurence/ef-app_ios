import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingUserWithNoUnreadMessages_NewsPresenterShould: XCTestCase {

    var viewModel: StubbedUserViewModel!
    var userWidgetViewModel: UserWidgetComponentViewModel!
    var indexPath: IndexPath!
    var newsViewModelFactory: StubNewsViewModelProducer!
    var context: NewsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        userWidgetViewModel = .random
        userWidgetViewModel.hasUnreadMessages = false
        viewModel = StubbedUserViewModel(viewModel: userWidgetViewModel)
        indexPath = IndexPath(row: 0, section: 0)

        newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }

    func testNotShowTheHighlightedUserPrompt() {
        XCTAssertFalse(context.newsScene.stubbedUserWidgetComponent.didShowHighlightedPrompt)
    }

    func testShowTheDefaultUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didShowStandardPrompt)
    }

    func testHideTheHighlightedUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didHideHighlightedPrompt)
    }

    func testNotHideTheStandardUserPrompt() {
        XCTAssertFalse(context.newsScene.stubbedUserWidgetComponent.didHideStandardPrompt)
    }

}
