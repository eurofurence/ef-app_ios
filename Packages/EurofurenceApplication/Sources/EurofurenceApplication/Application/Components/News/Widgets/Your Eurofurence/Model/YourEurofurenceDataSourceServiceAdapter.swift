import Combine
import EurofurenceModel

public class YourEurofurenceDataSourceServiceAdapter: YourEurofurenceDataSource {
        
    public let state = CurrentValueSubject<AuthenticatedUserSummary?, Never>(nil)
    
    public init(authenticationService: AuthenticationService, privateMessagesService: PrivateMessagesService) {
        authenticationService.add(UpdateSummaryWhenAuthenticationStateChanges(adapter: self))
        privateMessagesService.add(UpdateSummaryWhenUnreadMessageCountChanges(adapter: self))
    }
    
    func userChanged(to newUser: User?) {
        if let user = newUser {
            state.value = AuthenticatedUserSummary(
                regNumber: user.registrationNumber,
                username: user.username,
                unreadMessageCount: 0
            )
        } else {
            state.value = nil
        }
    }
    
    func unreadMessageCountDidChange(to newCount: Int) {
        state.value?.unreadMessageCount = newCount
    }
    
    private struct UpdateSummaryWhenAuthenticationStateChanges: AuthenticationStateObserver {
        
        let adapter: YourEurofurenceDataSourceServiceAdapter
        
        func userAuthenticated(_ user: User) {
            adapter.userChanged(to: user)
        }
        
        func userUnauthenticated() {
            adapter.userChanged(to: nil)
        }
        
    }
    
    private class UpdateSummaryWhenUnreadMessageCountChanges: PrivateMessagesObserver {
        
        private let adapter: YourEurofurenceDataSourceServiceAdapter
        
        init(adapter: YourEurofurenceDataSourceServiceAdapter) {
            self.adapter = adapter
        }
        
        func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
            adapter.unreadMessageCountDidChange(to: unreadCount)
        }
        
        func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message]) {}
        func privateMessagesServiceDidFailToLoadMessages() {}
        
    }
    
}
