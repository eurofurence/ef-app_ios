import EurofurenceModel

class CapturingLoginObserver {

    private(set) var notifiedLoginSucceeded = false
    private(set) var notifiedLoginFailed = false
    private(set) var loggedInUser: User?
    func completionHandler(_ result: LoginResult) {
        switch result {
        case .success(let user):
            self.notifiedLoginSucceeded = true
            self.loggedInUser = user
        case .failure:
            self.notifiedLoginFailed = true
        }
    }

}
