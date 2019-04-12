@testable import Eurofurence
import EurofurenceModel

class CapturingLoginModuleDelegate: LoginModuleDelegate {

    private(set) var loginCancelled = false
    func loginModuleDidCancelLogin() {
        loginCancelled = true
    }

    private(set) var loginFinishedSuccessfully = false
    func loginModuleDidLoginSuccessfully() {
        loginFinishedSuccessfully = true
    }

}
