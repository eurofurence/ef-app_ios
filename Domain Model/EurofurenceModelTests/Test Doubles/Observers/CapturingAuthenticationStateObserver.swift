import EurofurenceModel
import Foundation

class CapturingAuthenticationStateObserver: AuthenticationStateObserver {

    private(set) var capturedLoggedInUser: User?
    func userAuthenticated(_ user: User) {
        capturedLoggedInUser = user
    }

    var loggedOut = false
    func userDidLogout() {
        loggedOut = true
    }

    private(set) var logoutDidFail = false
    func userDidFailToLogout() {
        logoutDidFail = true
    }

}
