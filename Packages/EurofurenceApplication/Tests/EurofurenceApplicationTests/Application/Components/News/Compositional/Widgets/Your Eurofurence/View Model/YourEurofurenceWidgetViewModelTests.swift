import Combine
import EurofurenceApplication
import EurofurenceModel
import ObservedObject
import XCTest
import XCTRouter

class YourEurofurenceWidgetViewModelTests: XCTestCase {
    
    private func makeViewModel(
        dataSource: StubYourEurofurenceDataSource
    ) -> DataSourceBackedYourEurofurenceWidgetViewModel {
        let factory = YourEurofurenceWidgetViewModelFactory(dataSource: dataSource)
        let router = FakeContentRouter()
        
        return factory.makeViewModel(router: router)
    }
    
    func testUnauthenticatedUser() {
        let dataSource = StubYourEurofurenceDataSource()
        dataSource.enterState(nil)
        let viewModel = makeViewModel(dataSource: dataSource)
        
        XCTAssertEqual(String.anonymousUserLoginPrompt, viewModel.prompt)
        XCTAssertEqual(String.anonymousUserLoginDescription, viewModel.supplementaryPrompt)
        XCTAssertFalse(viewModel.isHighlightedForAttention)
    }
    
    func testAuthenticatedUser_NoNewMessages() {
        let dataSource = StubYourEurofurenceDataSource()
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 42, username: "User", unreadMessageCount: 0))
        let viewModel = makeViewModel(dataSource: dataSource)
        
        XCTAssertEqual("Welcome, User (42)", viewModel.prompt)
        XCTAssertEqual("You have no unread messages", viewModel.supplementaryPrompt)
        XCTAssertFalse(viewModel.isHighlightedForAttention)
    }
    
    func testAuthenticatedUser_OneNewMessage() {
        let dataSource = StubYourEurofurenceDataSource()
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 12, username: "Some Guy", unreadMessageCount: 1))
        let viewModel = makeViewModel(dataSource: dataSource)
        
        XCTAssertEqual("Welcome, Some Guy (12)", viewModel.prompt)
        XCTAssertEqual("You have 1 unread message", viewModel.supplementaryPrompt)
        XCTAssertTrue(viewModel.isHighlightedForAttention)
    }
    
    func testSendsUpdateNotificationsWhenPropertiesUpdate() {
        let dataSource = StubYourEurofurenceDataSource()
        let viewModel = makeViewModel(dataSource: dataSource)
        
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
        let dataSource = StubYourEurofurenceDataSource()
        dataSource.enterState(AuthenticatedUserSummary(regNumber: 18, username: "A Person", unreadMessageCount: 10))
        let viewModel = makeViewModel(dataSource: dataSource)
        
        XCTAssertEqual("Welcome, A Person (18)", viewModel.prompt)
        XCTAssertEqual("You have 10 unread messages", viewModel.supplementaryPrompt)
        XCTAssertTrue(viewModel.isHighlightedForAttention)
    }
    
    private class StubYourEurofurenceDataSource: YourEurofurenceDataSource {
        
        let state = CurrentValueSubject<AuthenticatedUserSummary?, Never>(nil)
        
        func enterState(_ state: AuthenticatedUserSummary?) {
            self.state.value = state
        }
        
    }
    
}
