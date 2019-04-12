import EurofurenceModel

class CapturingLogoutObserver {

    private(set) var didLogout = false
    private(set) var didFailToLogout = false
    func completionHandler(_ result: LogoutResult) {
        switch result {
        case .success:
            didLogout = true

        case .failure:
            didFailToLogout = true
        }
    }

}
