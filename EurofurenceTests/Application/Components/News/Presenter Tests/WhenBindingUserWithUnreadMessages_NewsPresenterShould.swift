import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingUserWithUnreadMessages_NewsPresenterShould: XCTestCase {

    var viewModel: StubbedUserViewModel!
    var userWidgetViewModel: UserWidgetComponentViewModel!
    var indexPath: IndexPath!
    var newsViewModelFactory: StubNewsViewModelProducer!
    var context: NewsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        userWidgetViewModel = .random
        userWidgetViewModel.hasUnreadMessages = true
        viewModel = StubbedUserViewModel(viewModel: userWidgetViewModel)
        indexPath = IndexPath(row: 0, section: 0)

        newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }

    func testShowTheHighlightedUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didShowHighlightedPrompt)
    }

    func testNotShowTheDefaultUserPrompt() {
        XCTAssertFalse(context.newsScene.stubbedUserWidgetComponent.didShowStandardPrompt)
    }

    func testNotHideTheHighlightedUserPrompt() {
        XCTAssertFalse(context.newsScene.stubbedUserWidgetComponent.didHideHighlightedPrompt)
    }

    func testHideTheDefaultUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didHideStandardPrompt)
    }

}
