import Combine
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class YourEurofurenceDataSourceTests: XCTestCase {
    
    func testInitiallyUnauthenticated() {
        let authenticationService = FakeAuthenticationService(authState: .loggedOut)
        let privateMessagesService = ControllablePrivateMessagesService()
        let adapter = YourEurofurenceDataSourceServiceAdapter(
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService
        )
        
        var toldNoSummaryAvailable = false
        let subscription = adapter
            .state
            .sink { (summary) in
                toldNoSummaryAvailable = summary == nil
            }
        
        defer {
            subscription.cancel()
        }
        
        XCTAssertTrue(toldNoSummaryAvailable)
    }
    
    func testAuthenticated_NoMessages() throws {
        let user = User(registrationNumber: 42, username: "User")
        let authenticationService = FakeAuthenticationService(authState: .loggedIn(user))
        let privateMessagesService = ControllablePrivateMessagesService()
        let adapter = YourEurofurenceDataSourceServiceAdapter(
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService
        )
        
        var actual: AuthenticatedUserSummary?
        let subscription = adapter
            .state
            .sink { (summary) in
                actual = summary
            }
        
        defer {
            subscription.cancel()
        }
        
        let expected = AuthenticatedUserSummary(regNumber: 42, username: "User", unreadMessageCount: 0)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAuthenticated_SomeMessages() throws {
        let user = User(registrationNumber: 42, username: "User")
        let authenticationService = FakeAuthenticationService(authState: .loggedIn(user))
        let privateMessagesService = ControllablePrivateMessagesService()
        let adapter = YourEurofurenceDataSourceServiceAdapter(
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService
        )
        
        privateMessagesService.simulateUnreadCountChanged(to: 3)
        
        var actual: AuthenticatedUserSummary?
        let subscription = adapter
            .state
            .sink { (summary) in
                actual = summary
            }
        
        defer {
            subscription.cancel()
        }
        
        let expected = AuthenticatedUserSummary(regNumber: 42, username: "User", unreadMessageCount: 3)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAuthenticatedThenUnauthenticated() throws {
        let user = User(registrationNumber: 42, username: "User")
        let authenticationService = FakeAuthenticationService(authState: .loggedIn(user))
        let privateMessagesService = ControllablePrivateMessagesService()
        let adapter = YourEurofurenceDataSourceServiceAdapter(
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService
        )
        
        var toldNoSummaryAvailable = false
        let subscription = adapter
            .state
            .sink { (summary) in
                toldNoSummaryAvailable = summary == nil
            }
        
        defer {
            subscription.cancel()
        }
        
        authenticationService.notifyObserversUserDidLogout()
        
        XCTAssertTrue(toldNoSummaryAvailable)
    }
    
    func testNewUserLoggingInDoesNotRevealOldUserMessageCount() throws {
        let firstUser = User(registrationNumber: 42, username: "First User")
        let authenticationService = FakeAuthenticationService(authState: .loggedIn(firstUser))
        let privateMessagesService = ControllablePrivateMessagesService()
        let adapter = YourEurofurenceDataSourceServiceAdapter(
            authenticationService: authenticationService,
            privateMessagesService: privateMessagesService
        )
        
        privateMessagesService.simulateUnreadCountChanged(to: 3)
        authenticationService.notifyObserversUserDidLogout()
        
        let secondUser = User(registrationNumber: 108, username: "Second User")
        authenticationService.notifyObserversUserDidLogin(secondUser)
        
        var actual: AuthenticatedUserSummary?
        let subscription = adapter
            .state
            .sink { (summary) in
                actual = summary
            }
        
        defer {
            subscription.cancel()
        }
        
        let expected = AuthenticatedUserSummary(regNumber: 108, username: "Second User", unreadMessageCount: 0)
        
        XCTAssertEqual(expected, actual)
    }
    
}
