import EurofurenceModel
import Foundation

class CapturingAuthenticationStateObserver: AuthenticationStateObserver {

    private(set) var capturedLoggedInUser: User?
    func userAuthenticated(_ user: User) {
        capturedLoggedInUser = user
    }

    var loggedOut = false
    func userUnauthenticated() {
        loggedOut = true
    }

}
