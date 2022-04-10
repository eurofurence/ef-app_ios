import Combine
import EurofurenceApplication
import EurofurenceModel
import ObservedObject
import XCTest
import XCTRouter

class YourEurofurenceWidgetViewModelTests: XCTestCase {
    
    private var dataSource: StubYourEurofurenceDataSource!
    private var router: FakeContentRouter!
    
    override func setUp() {
        super.setUp()
        
        dataSource = StubYourEurofurenceDataSource()
        router = FakeContentRouter()
    }
    
    private func makeViewModel() -> DataSourceBackedYourEurofurenceWidgetViewModel {
        let factory = YourEurofurenceWidgetViewModelFactory(dataSource: dataSource)
        return factory.makeViewModel(router: router)
    }
    
    func testUnauthenticatedUser() {
        dataSource.enterState(nil)
        let viewModel = makeViewModel()
        
        XCTAssertEqual(String.anonymousUserLoginPrompt, viewModel.prompt)
        XCTAssertEqual(String.anonymousUserLoginDescription, viewModel.supplementaryPrompt)
        XCTAssertFalse(viewModel.isHighlightedForAttention)
    }
    
    func testAuthenticatedUser_NoNewMessages() {
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 42, username: "User", unreadMessageCount: 0))
        let viewModel = makeViewModel()
        
        XCTAssertEqual("Welcome, User (42)", viewModel.prompt)
        XCTAssertEqual("You have no unread messages", viewModel.supplementaryPrompt)
        XCTAssertFalse(viewModel.isHighlightedForAttention)
    }
    
    func testAuthenticatedUser_OneNewMessage() {
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 12, username: "Some Guy", unreadMessageCount: 1))
        let viewModel = makeViewModel()
        
        XCTAssertEqual("Welcome, Some Guy (12)", viewModel.prompt)
        XCTAssertEqual("You have 1 unread message", viewModel.supplementaryPrompt)
        XCTAssertTrue(viewModel.isHighlightedForAttention)
    }
    
    func testSendsUpdateNotificationsWhenPropertiesUpdate() {
        let viewModel = makeViewModel()
        
        let promptPublisher = viewModel.publisher(for: \.prompt, options: [])
        let supplementaryPromptPublisher = viewModel.publisher(for: \.supplementaryPrompt, options: [])
        let isHighlightedForAttentionPublisher = viewModel.publisher(for: \.isHighlightedForAttention, options: [])
        
        var observedPrompt: String?
        var observedSupplementaryPrompt: String?
        var observedHighlightedForAttention: Bool?
        
        let upstream = Publishers.CombineLatest3(
            promptPublisher,
            supplementaryPromptPublisher,
            isHighlightedForAttentionPublisher
        )
        
        let subscription = upstream
            .sink { (prompt, supplementaryPrompt, isHighlightedForAttention) in
                observedPrompt = prompt
                observedSupplementaryPrompt = supplementaryPrompt
                observedHighlightedForAttention = isHighlightedForAttention
            }
        
        defer {
            subscription.cancel()
        }
        
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 12, username: "Some Guy", unreadMessageCount: 1))
        
        XCTAssertEqual("Welcome, Some Guy (12)", observedPrompt)
        XCTAssertEqual("You have 1 unread message", observedSupplementaryPrompt)
        XCTAssertEqual(true, observedHighlightedForAttention)
    }
    
    func testAuthenticatedUser_MultipleNewMessages() {
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 18, username: "A Person", unreadMessageCount: 10))
        let viewModel = makeViewModel()
        
        XCTAssertEqual("Welcome, A Person (18)", viewModel.prompt)
        XCTAssertEqual("You have 10 unread messages", viewModel.supplementaryPrompt)
        XCTAssertTrue(viewModel.isHighlightedForAttention)
    }
    
    func testCellSelectedShowsMessages() {
        let viewModel = makeViewModel()
        viewModel.showPersonalisedContent()
        
        router.assertRouted(to: MessagesRouteable())
    }
    
}
