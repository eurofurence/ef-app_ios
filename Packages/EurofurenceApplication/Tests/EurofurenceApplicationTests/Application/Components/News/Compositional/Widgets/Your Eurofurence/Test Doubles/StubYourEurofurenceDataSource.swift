import Combine
import EurofurenceApplication

class StubYourEurofurenceDataSource: YourEurofurenceDataSource {
    
    let state = CurrentValueSubject<AuthenticatedUserSummary?, Never>(nil)
    
    func enterState(_ state: AuthenticatedUserSummary?) {
        self.state.value = state
    }
    
}
